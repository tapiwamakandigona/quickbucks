import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import 'common.dart';

const _green = PdfColor.fromInt(0xFF1B6E3C);
const _gold = PdfColor.fromInt(0xFFC9A227);
const _red = PdfColor.fromInt(0xFFB3261E);

/// Builds and shares the full ledger PDF for [cycle] (SPEC 6).
Future<void> exportCyclePdf(BuildContext context, Cycle cycle) async {
  final app = context.read<AppState>();
  final repo = app.repo;
  try {
    final members = await repo.membersOf(cycle.id);
    final contributions = await repo.contributionsOf(cycle.id);
    final loans = await repo.loansOf(cycle.id);
    final outstandingByLoan = <String, int>{
      for (final l in loans)
        if (l.status == 'active') l.id: await repo.outstandingOf(l)
    };
    final paymentsByLoan = <String, List<LoanPayment>>{};
    for (final l in loans) {
      paymentsByLoan[l.id] = await (repo.db.select(repo.db.loanPayments)
            ..where((p) => p.loanId.equals(l.id)))
          .get();
    }
    final totals = await repo.totals(cycle.id);
    final shareOut = await repo.shareOutOf(cycle.id);

    final doc = _buildPdf(
      cycle: cycle,
      members: members,
      contributions: contributions,
      loans: loans,
      outstandingByLoan: outstandingByLoan,
      paymentsByLoan: paymentsByLoan,
      cash: totals.cashOnHandCents,
      poolValue: totals.poolValueCents,
      shareOut: shareOut,
    );
    await Printing.sharePdf(
        bytes: await doc.save(),
        filename:
            'QuickBucks ${cycle.name} ${iso(today())}.pdf'.replaceAll('/', '-'));
  } catch (e) {
    if (context.mounted) {
      showNote(context, 'Could not make the PDF: ${friendlyError(e)}', error: true);
    }
  }
}

pw.Document _buildPdf({
  required Cycle cycle,
  required List<Member> members,
  required List<Contribution> contributions,
  required List<Loan> loans,
  required Map<String, int> outstandingByLoan,
  required Map<String, List<LoanPayment>> paymentsByLoan,
  required int cash,
  required int poolValue,
  required (ShareOut, List<ShareOutLine>)? shareOut,
}) {
  final doc = pw.Document(title: 'QuickBucks — ${cycle.name}');
  String nameOf(String id) => members.firstWhere((m) => m.id == id).name;
  String d(String isoDate) => isoDate; // dates already yyyy-MM-dd

  final saturdays =
      contributions.map((c) => c.saturday).toSet().toList()..sort();
  final ticked = {
    for (final c in contributions) '${c.memberId}|${c.saturday}': c.amountCents
  };

  pw.Widget header(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold, color: _green)),
      );

  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    footer: (ctx) => pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text('QuickBucks — page ${ctx.pageNumber}/${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
    ),
    build: (ctx) => [
      // ── Title & summary ──────────────────────────────────────────────
      pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
            color: _green, borderRadius: pw.BorderRadius.circular(8)),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('QuickBucks',
                  style: pw.TextStyle(
                      color: _gold,
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text(cycle.name,
                  style: const pw.TextStyle(
                      color: PdfColors.white, fontSize: 14)),
            ]),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
              pw.Text('${d(cycle.startDate)} → ${cycle.endDate ?? 'ongoing'}',
                  style: const pw.TextStyle(
                      color: PdfColors.white, fontSize: 11)),
              pw.Text('Printed ${iso(today())}',
                  style: const pw.TextStyle(
                      color: PdfColors.white, fontSize: 11)),
            ]),
          ],
        ),
      ),
      pw.SizedBox(height: 12),
      pw.Row(children: [
        _stat('Cash in the box', money(cash)),
        pw.SizedBox(width: 12),
        _stat('Pool value (incl. loans out)', money(poolValue)),
        pw.SizedBox(width: 12),
        _stat('Members', '${members.length} (${members.fold(0, (s, m) => s + m.multiplier)} shares)'),
      ]),

      // ── Members ──────────────────────────────────────────────────────
      header('Members'),
      pw.TableHelper.fromTextArray(
        headers: ['Member', 'Multiplier', 'Pays each Saturday'],
        data: [
          for (final m in members)
            [m.name, '×${m.multiplier}', money(m.multiplier * cycle.weeklyUnitCents)]
        ],
        headerStyle: pw.TextStyle(
            color: PdfColors.white, fontWeight: pw.FontWeight.bold),
        headerDecoration: const pw.BoxDecoration(color: _green),
        cellStyle: const pw.TextStyle(fontSize: 10),
      ),

      // ── Contribution grid ────────────────────────────────────────────
      header('Weekly payments (✓ = paid)'),
      if (saturdays.isEmpty)
        pw.Text('No weekly payments recorded.',
            style: const pw.TextStyle(fontSize: 10))
      else
        pw.TableHelper.fromTextArray(
          headers: ['Saturday', ...members.map((m) => m.name)],
          data: [
            for (final s in saturdays)
              [
                s,
                ...members.map((m) =>
                    ticked.containsKey('${m.id}|$s') ? '✓' : '—'),
              ]
          ],
          headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: _green),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.center,
          cellAlignments: {0: pw.Alignment.centerLeft},
        ),

      // ── Loan register ────────────────────────────────────────────────
      header('Loans'),
      if (loans.isEmpty)
        pw.Text('No loans in this cycle.',
            style: const pw.TextStyle(fontSize: 10))
      else
        pw.TableHelper.fromTextArray(
          headers: [
            'Member', 'Taken', 'Amount', 'Owed (+20%)', 'Due Sat',
            'Paid', 'Status'
          ],
          data: [
            for (final l in loans)
              [
                nameOf(l.memberId),
                d(l.loanDate),
                money(l.principalCents),
                money(l.owedCents),
                d(l.dueDate),
                money((paymentsByLoan[l.id] ?? [])
                    .fold(0, (s, p) => s + p.amountCents)),
                switch (l.status) {
                  'active' =>
                    'open — ${money(outstandingByLoan[l.id] ?? 0)} left',
                  'paid' => 'paid off',
                  _ => 'rolled over',
                },
              ]
          ],
          headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: _green),
          cellStyle: const pw.TextStyle(fontSize: 9),
        ),

      // ── Payment log ──────────────────────────────────────────────────
      if (paymentsByLoan.values.any((l) => l.isNotEmpty)) ...[
        header('Loan payments'),
        pw.TableHelper.fromTextArray(
          headers: ['Member', 'Paid on', 'Amount'],
          data: [
            for (final l in loans)
              for (final p in paymentsByLoan[l.id] ?? <LoanPayment>[])
                [nameOf(l.memberId), d(p.paidOn), money(p.amountCents)]
          ],
          headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: _green),
          cellStyle: const pw.TextStyle(fontSize: 9),
        ),
      ],

      // ── Share-out ────────────────────────────────────────────────────
      if (shareOut != null) ...[
        header('Share-out (final balance sheet)'),
        pw.Text(
            'Pot shared: ${money(shareOut.$1.potCents)}   ·   Cash paid out: ${money(shareOut.$1.cashCents)}   ·   Date: ${d(shareOut.$1.createdOn)}',
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: ['Member', 'Shares', 'Share of pot', 'Owed deducted', 'Final payout'],
          data: [
            for (final l in shareOut.$2)
              [
                nameOf(l.memberId),
                '×${l.multiplier}',
                money(l.shareCents),
                l.debtDeductedCents > 0 ? money(l.debtDeductedCents) : '—',
                money(l.payoutCents),
              ]
          ],
          headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: _green),
          cellStyle: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        if (shareOut.$2.any((l) => l.payoutCents < 0))
          pw.Text(
              'Negative payout = the member still owes the group that amount.',
              style: pw.TextStyle(fontSize: 9, color: _red)),
      ],
    ],
  ));
  return doc;
}

pw.Widget _stat(String label, String value) => pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6)),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label,
                  style: const pw.TextStyle(
                      fontSize: 9, color: PdfColors.grey700)),
              pw.SizedBox(height: 2),
              pw.Text(value,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
            ]),
      ),
    );
