/// PDF render harness: builds the real ledger + member statement documents
/// with the shared seed and writes them to test/pdf_out/ for visual review.
/// Doubles as a "PDF generation does not crash" regression test.
@Tags(['golden'])
library;

import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart' show iso;
import 'package:quickbucks/ui/reports.dart';
import 'package:sqlite3/open.dart';

import 'support/seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        try {
          return DynamicLibrary.open('libsqlite3.so');
        } on ArgumentError {
          return DynamicLibrary.open('libsqlite3.so.0');
        }
      });
    }
  });

  test('cycle ledger and member statement PDFs build and save', () async {
    final state = await seedAppState();
    final repo = state.repo;
    final cycle = state.cycle!;
    final theme = await pdfTheme();
    final outDir = Directory('test/pdf_out')..createSync(recursive: true);

    // ── Full ledger (same data gathering as exportCyclePdf) ──
    final members = await repo.membersOf(cycle.id);
    final contributions = await repo.contributionsOf(cycle.id);
    final loans = await repo.loansOf(cycle.id);
    final outstandingByLoan = <String, int>{
      for (final l in loans)
        if (l.status == 'active') l.id: await repo.outstandingOf(l)
    };
    final paymentsByLoan = <String, List<LoanPayment>>{
      for (final l in loans) l.id: await repo.paymentRowsOf(l.id)
    };
    final totals = await repo.totals(cycle.id);
    final ledger = buildCycleLedgerDoc(
      theme: theme,
      cycle: cycle,
      members: members,
      contributions: contributions,
      loans: loans,
      outstandingByLoan: outstandingByLoan,
      paymentsByLoan: paymentsByLoan,
      cash: totals.cashOnHandCents,
      poolValue: totals.poolValueCents,
      shareOut: await repo.shareOutOf(cycle.id),
    );
    final ledgerBytes = await ledger.save();
    expect(ledgerBytes.length, greaterThan(1000));
    File('${outDir.path}/ledger.pdf').writeAsBytesSync(ledgerBytes);

    // ── Mary's statement (same gathering as exportMemberPdf) ──
    final mary = members.firstWhere((m) => m.name == 'Mary');
    final saturdays = state.saturdaysSoFar();
    final paid = [
      for (final s in saturdays)
        if (state.isTicked(mary.id, s)) s
    ];
    final missed = [
      for (final s in saturdays)
        if (!state.isTicked(mary.id, s)) s
    ];
    final maryLoans = loans.where((l) => l.memberId == mary.id).toList();
    final owed = maryLoans
        .where((l) => l.status == 'active')
        .fold(0, (s, l) => s + (outstandingByLoan[l.id] ?? 0));
    final statement = buildMemberStatementDoc(
      theme: theme,
      cycle: cycle,
      member: mary,
      saturdays: saturdays,
      paidIso: {for (final t in paid) iso(t)},
      missed: missed,
      loans: maryLoans,
      paymentsByLoan: paymentsByLoan,
      outstandingByLoan: outstandingByLoan,
      owed: owed,
      weekly: mary.multiplier * cycle.weeklyUnitCents,
    );
    final stmtBytes = await statement.save();
    expect(stmtBytes.length, greaterThan(1000));
    File('${outDir.path}/mary_statement.pdf').writeAsBytesSync(stmtBytes);

    // ── Share-out slips (end the seeded cycle, then build) ──
    await repo.endCycle(cycle);
    final so = (await repo.shareOutOf(cycle.id))!;
    final savedByMember = <String, int>{};
    for (final c in contributions) {
      savedByMember[c.memberId] =
          (savedByMember[c.memberId] ?? 0) + c.amountCents;
    }
    final slips = buildShareOutSlipsDoc(
      theme: theme,
      cycle: cycle,
      members: members,
      shareOut: so.$1,
      lines: so.$2,
      savedByMember: savedByMember,
    );
    final slipBytes = await slips.save();
    expect(slipBytes.length, greaterThan(1000));
    File('${outDir.path}/shareout_slips.pdf').writeAsBytesSync(slipBytes);
  });
}
