import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

/// PDF theme with a bundled font that covers every glyph we print
/// (the built-in Helvetica is latin-1 only: no tick marks or long dashes).
Future<pw.ThemeData> pdfTheme() async {
  final base = pw.Font.ttf(
    await rootBundle.load('assets/fonts/DejaVuSans.ttf'),
  );
  final bold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'),
  );
  return pw.ThemeData.withFont(base: base, bold: bold);
}

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
        if (l.status == 'active') l.id: await repo.outstandingOf(l),
    };
    final paymentsByLoan = <String, List<LoanPayment>>{};
    for (final l in loans) {
      paymentsByLoan[l.id] = await (repo.db.select(
        repo.db.loanPayments,
      )..where((p) => p.loanId.equals(l.id))).get();
    }
    final totals = await repo.totals(cycle.id);
    final shareOut = await repo.shareOutOf(cycle.id);

    final doc = buildCycleLedgerDoc(
      theme: await pdfTheme(),
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
      filename: 'QuickBucks ${cycle.name} ${iso(today())}.pdf'.replaceAll(
        '/',
        '-',
      ),
    );
  } catch (e) {
    if (context.mounted) {
      showNote(
        context,
        'Could not make the PDF: ${friendlyError(e)}',
        error: true,
      );
    }
  }
}

pw.Document buildCycleLedgerDoc({
  required pw.ThemeData theme,
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
  final doc = pw.Document(title: 'QuickBucks — ${cycle.name}', theme: theme);
  String nameOf(String id) => members.firstWhere((m) => m.id == id).name;
  String d(String isoDate) => prettyDate(fromIso(isoDate));

  final saturdays = contributions.map((c) => c.saturday).toSet().toList()
    ..sort();
  final ticked = {
    for (final c in contributions) '${c.memberId}|${c.saturday}': c.amountCents,
  };

  pw.Widget header(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: _green,
      ),
    ),
  );

  void addSection(List<pw.Widget> children) {
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'QuickBucks — page ${ctx.pageNumber}/${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
          ),
        ),
        build: (ctx) => children,
      ),
    );
  }

  // ── Page 1: title, summary & members ───────────────────────────────
  addSection([
    pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _green,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'QuickBucks',
                style: pw.TextStyle(
                  color: _gold,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                cycle.name,
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 14),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '${d(cycle.startDate)} → ${cycle.endDate == null ? 'ongoing' : d(cycle.endDate!)}',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 11),
              ),
              pw.Text(
                'Printed ${prettyDate(today())}',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    ),
    pw.SizedBox(height: 12),
    pw.Row(
      children: [
        _stat('Cash in the box', money(cash)),
        pw.SizedBox(width: 12),
        _stat('Pool value (incl. loans out)', money(poolValue)),
        pw.SizedBox(width: 12),
        _stat(
          'Members',
          '${members.length} (${members.fold(0, (s, m) => s + m.multiplier)} shares)',
        ),
      ],
    ),
    header('Members'),
    pw.TableHelper.fromTextArray(
      headers: ['Member', 'Multiplier', 'Pays each Saturday'],
      data: [
        for (final m in members)
          [
            m.name,
            '×${m.multiplier}',
            money(m.multiplier * cycle.weeklyUnitCents),
          ],
      ],
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(color: _green),
      cellStyle: const pw.TextStyle(fontSize: 10),
    ),
  ]);

  // ── Page 2: the Saturday book ──────────────────────────────────────
  addSection([
    header('Weekly payments (✓ = paid, ✗ = missed)'),
    if (saturdays.isEmpty)
      pw.Text(
        'No weekly payments recorded.',
        style: const pw.TextStyle(fontSize: 10),
      )
    else
      pw.TableHelper.fromTextArray(
        headers: ['Saturday', ...members.map((m) => m.name)],
        data: [
          for (final s in saturdays)
            [
              shortDate(fromIso(s)),
              ...members.map(
                (m) => ticked.containsKey('${m.id}|$s')
                    ? '✓'
                    : pw.Text(
                        '✗',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: _red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
              ),
            ],
        ],
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(color: _green),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellAlignment: pw.Alignment.center,
        cellAlignments: {0: pw.Alignment.centerLeft},
      ),
  ]);

  // ── Page 3: loans & their payments ─────────────────────────────────
  addSection([
    header('Loans'),
    if (loans.isEmpty)
      pw.Text(
        'No loans in this cycle.',
        style: const pw.TextStyle(fontSize: 10),
      )
    else
      pw.TableHelper.fromTextArray(
        headers: [
          'Member',
          'Taken',
          'Amount',
          'Owed (+20%)',
          'Due Sat',
          'Paid',
          'Status',
        ],
        data: [
          for (final l in loans)
            [
              nameOf(l.memberId),
              d(l.loanDate),
              money(l.principalCents),
              money(l.owedCents),
              d(l.dueDate),
              money(
                (paymentsByLoan[l.id] ?? []).fold(
                  0,
                  (s, p) => s + p.amountCents,
                ),
              ),
              switch (l.status) {
                'active' =>
                  'open — ${money(outstandingByLoan[l.id] ?? 0)} left',
                'paid' => 'paid off',
                _ => 'rolled over',
              },
            ],
        ],
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(color: _green),
        cellStyle: const pw.TextStyle(fontSize: 9),
      ),
    if (paymentsByLoan.values.any((l) => l.isNotEmpty)) ...[
      header('Loan payments'),
      pw.TableHelper.fromTextArray(
        headers: ['Member', 'Paid on', 'Amount'],
        data: [
          for (final l in loans)
            for (final p in paymentsByLoan[l.id] ?? <LoanPayment>[])
              [nameOf(l.memberId), d(p.paidOn), money(p.amountCents)],
        ],
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(color: _green),
        cellStyle: const pw.TextStyle(fontSize: 9),
      ),
    ],
  ]);

  // ── Page 4: share-out (only once the cycle is shared out) ──────────
  if (shareOut != null) {
    addSection([
      header('Share-out (final balance sheet)'),
      pw.Text(
        'Pot shared: ${money(shareOut.$1.potCents)}   ·   Cash paid out: ${money(shareOut.$1.cashCents)}   ·   Date: ${d(shareOut.$1.createdOn)}',
        style: const pw.TextStyle(fontSize: 10),
      ),
      pw.SizedBox(height: 6),
      pw.TableHelper.fromTextArray(
        headers: [
          'Member',
          'Shares',
          'Share of pot',
          'Owed deducted',
          'Final payout',
        ],
        data: [
          for (final l in shareOut.$2)
            [
              nameOf(l.memberId),
              '×${l.multiplier}',
              money(l.shareCents),
              l.debtDeductedCents > 0 ? money(l.debtDeductedCents) : '—',
              money(l.payoutCents),
            ],
        ],
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(color: _green),
        cellStyle: const pw.TextStyle(fontSize: 10),
      ),
      pw.SizedBox(height: 4),
      if (shareOut.$2.any((l) => l.payoutCents < 0))
        pw.Text(
          'Negative payout = the member still owes the group that amount.',
          style: pw.TextStyle(fontSize: 9, color: _red),
        ),
    ]);
  }

  return doc;
}

pw.Widget _stat(String label, String value) => pw.Expanded(
  child: pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey300),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  ),
);

/// One member's statement PDF — small enough to share on WhatsApp and show
/// at the market. Owner request (v1.1 feature 1).
Future<void> exportMemberPdf(BuildContext context, Member member) async {
  final app = context.read<AppState>();
  final repo = app.repo;
  final cycle = app.cycle!;
  try {
    final saturdays = app.saturdaysSoFar();
    final weekly = member.multiplier * cycle.weeklyUnitCents;
    final paid = [
      for (final s in saturdays)
        if (app.isTicked(member.id, s)) s,
    ];
    final missed = [
      for (final s in saturdays)
        if (!app.isTicked(member.id, s)) s,
    ];
    final loans = app.loans.where((l) => l.memberId == member.id).toList();
    final paymentsByLoan = <String, List<LoanPayment>>{
      for (final l in loans) l.id: await repo.paymentRowsOf(l.id),
    };
    final owed = loans
        .where((l) => l.status == 'active')
        .fold(0, (s, l) => s + (app.outstandingByLoan[l.id] ?? 0));

    final doc = buildMemberStatementDoc(
      theme: await pdfTheme(),
      cycle: cycle,
      member: member,
      saturdays: saturdays,
      paidIso: {for (final t in paid) iso(t)},
      missed: missed,
      loans: loans,
      paymentsByLoan: paymentsByLoan,
      outstandingByLoan: app.outstandingByLoan,
      owed: owed,
      weekly: weekly,
    );
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '${member.name} statement ${iso(today())}.pdf'.replaceAll(
        '/',
        '-',
      ),
    );
  } catch (e) {
    if (context.mounted) {
      showNote(
        context,
        'Could not make the PDF: ${friendlyError(e)}',
        error: true,
      );
    }
  }
}

/// Builds one member's statement document (pure; unit-testable).
pw.Document buildMemberStatementDoc({
  required pw.ThemeData theme,
  required Cycle cycle,
  required Member member,
  required List<DateTime> saturdays,
  required Set<String> paidIso,
  required List<DateTime> missed,
  required List<Loan> loans,
  required Map<String, List<LoanPayment>> paymentsByLoan,
  required Map<String, int> outstandingByLoan,
  required int owed,
  required int weekly,
}) {
  final doc = pw.Document(theme: theme);
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Container(
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            color: _green,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${member.name} — statement',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${cycle.name} · ${prettyDate(today())}',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 10),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            _stat('Saved so far', money(paidIso.length * weekly)),
            pw.SizedBox(width: 8),
            _stat(
              'Multiplier',
              '×${member.multiplier} (${money(weekly)}/week)',
            ),
            pw.SizedBox(width: 8),
            _stat('Still owes', money(owed)),
          ],
        ),
        pw.SizedBox(height: 14),
        pw.Text(
          'Weekly payments',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: _green,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Paid ${paidIso.length} of ${saturdays.length} Saturdays'
          '${missed.isEmpty ? ' — none missed.' : '. Missing: ${missed.map(prettyDate).join(', ')}'}',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 3,
          runSpacing: 3,
          children: [
            for (final s in saturdays)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: pw.BoxDecoration(
                  color: paidIso.contains(iso(s))
                      ? PdfColor.fromInt(0xFFDFF0E2)
                      : PdfColor.fromInt(0xFFF8E3E1),
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  '${s.day}/${s.month} ${paidIso.contains(iso(s)) ? '✓' : '✗'}',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
          ],
        ),
        if (loans.isNotEmpty) ...[
          pw.SizedBox(height: 14),
          pw.Text(
            'Loans',
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: _green,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: _green),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headers: ['Taken', 'Amount', 'Owed (20%)', 'Due', 'Paid', 'Status'],
            data: [
              for (final l in loans)
                [
                  prettyDate(fromIso(l.loanDate)),
                  money(l.principalCents),
                  money(l.owedCents),
                  prettyDate(fromIso(l.dueDate)),
                  money(
                    (paymentsByLoan[l.id] ?? []).fold(
                      0,
                      (s, p) => s + p.amountCents,
                    ),
                  ),
                  l.status == 'active'
                      ? '${money(outstandingByLoan[l.id] ?? 0)} left'
                      : l.status == 'paid'
                      ? 'Paid off'
                      : 'Rolled over',
                ],
            ],
          ),
        ],
        pw.SizedBox(height: 16),
        pw.Text(
          'Made with QuickBucks',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
        ),
      ],
    ),
  );
  return doc;
}

/// Share-out slips: one small slip per member, three to an A4 page with
/// dashed cut lines — the treasurer hands each member her own slip.
pw.Document buildShareOutSlipsDoc({
  required pw.ThemeData theme,
  required Cycle cycle,
  required List<Member> members,
  required ShareOut shareOut,
  required List<ShareOutLine> lines,
  required Map<String, int> savedByMember,
}) {
  final doc = pw.Document(
    title: '${cycle.name} — share-out slips',
    theme: theme,
  );
  String nameOf(String id) => members.firstWhere((m) => m.id == id).name;

  pw.Widget row(String label, String value, {bool strong = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 3),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: strong ? 14 : 10,
                fontWeight: strong ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  pw.Widget slip(ShareOutLine l) => pw.Container(
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        color: PdfColors.grey600,
        style: pw.BorderStyle.dashed,
      ),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              nameOf(l.memberId),
              style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${cycle.name} · ${prettyDate(fromIso(shareOut.createdOn))}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Divider(color: PdfColors.grey400, height: 10),
        row(
          'Saved this cycle (×${l.multiplier})',
          money(savedByMember[l.memberId] ?? 0),
        ),
        row('Share of the pot', money(l.shareCents)),
        if (l.debtDeductedCents > 0)
          row('Loan still owed (deducted)', '− ${money(l.debtDeductedCents)}'),
        pw.Divider(color: PdfColors.grey400, height: 10),
        row(
          l.payoutCents < 0 ? 'Still owes the group' : 'Takes home',
          money(l.payoutCents.abs()),
          strong: true,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Made with QuickBucks',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
        ),
      ],
    ),
  );

  for (var i = 0; i < lines.length; i += 3) {
    final chunk = lines.sublist(i, i + 3 > lines.length ? lines.length : i + 3);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) => pw.Column(
          children: [
            for (final l in chunk) ...[slip(l), pw.SizedBox(height: 18)],
          ],
        ),
      ),
    );
  }
  return doc;
}

/// Gathers data and shares the share-out slips PDF.
Future<void> exportShareOutSlips(BuildContext context, Cycle cycle) async {
  final app = context.read<AppState>();
  final repo = app.repo;
  try {
    final so = await repo.shareOutOf(cycle.id);
    if (so == null) return;
    final members = await repo.membersOf(cycle.id);
    final contributions = await repo.contributionsOf(cycle.id);
    final savedByMember = <String, int>{};
    for (final c in contributions) {
      savedByMember[c.memberId] =
          (savedByMember[c.memberId] ?? 0) + c.amountCents;
    }
    final doc = buildShareOutSlipsDoc(
      theme: await pdfTheme(),
      cycle: cycle,
      members: members,
      shareOut: so.$1,
      lines: so.$2,
      savedByMember: savedByMember,
    );
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '${cycle.name} share-out slips.pdf'.replaceAll('/', '-'),
    );
  } catch (e) {
    if (context.mounted) {
      showNote(
        context,
        'Could not make the slips: ${friendlyError(e)}',
        error: true,
      );
    }
  }
}
