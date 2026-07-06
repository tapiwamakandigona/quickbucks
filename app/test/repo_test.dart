import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:sqlite3/open.dart';

void main() {
  late AppDb db;
  late Repo repo;

  setUpAll(() {
    // Some Linux environments ship only libsqlite3.so.0 (no dev symlink).
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

  setUp(() {
    db = AppDb(NativeDatabase.memory());
    repo = Repo(db);
  });

  tearDown(() => db.close());

  Future<(Cycle, List<Member>)> makeCycle() async {
    final id = await repo.createCycle(
      name: '2026 Round 1',
      startDate: domain.day(2026, 2, 1), // the real cycle (SPEC 7)
      endDate: domain.day(2026, 7, 26),
      members: [
        MemberInput('Mary', 3),
        MemberInput('Jane', 2),
        MemberInput('Ruth', 1),
      ],
    );
    final cycle = await repo.activeCycle();
    expect(cycle!.id, id);
    return (cycle, await repo.membersOf(id));
  }

  test('single active cycle enforced', () async {
    await makeCycle();
    expect(
      () => repo.createCycle(
          name: 'x',
          startDate: domain.day(2026, 8, 1),
          members: [MemberInput('A', 1)]),
      throwsStateError,
    );
  });

  test('contribution amount = weekly unit x multiplier; Saturdays only',
      () async {
    final (cycle, members) = await makeCycle();
    final mary = members.firstWhere((m) => m.name == 'Mary');
    await repo.tickContribution(
        cycle: cycle, member: mary, saturday: domain.day(2026, 2, 7));
    final rows = await repo.contributionsOf(cycle.id);
    expect(rows.single.amountCents, 3000); // $10 x 3
    expect(
      () => repo.tickContribution(
          cycle: cycle, member: mary, saturday: domain.day(2026, 2, 8)),
      throwsArgumentError, // not a Saturday
    );
    // double-tick rejected by unique key
    expect(
      () => repo.tickContribution(
          cycle: cycle, member: mary, saturday: domain.day(2026, 2, 7)),
      throwsA(anything),
    );
    await repo.untickContribution(mary.id, domain.day(2026, 2, 7));
    expect(await repo.contributionsOf(cycle.id), isEmpty);
  });

  test('full Mary story through the database (SPEC 3.5)', () async {
    final (cycle, members) = await makeCycle();
    final mary = members.firstWhere((m) => m.name == 'Mary');

    final loanId = await repo.takeLoan(
        cycle: cycle,
        member: mary,
        principalCents: 10000,
        loanDate: domain.day(2026, 7, 1));
    var loans = await repo.loansOf(cycle.id);
    expect(loans.single.owedCents, 12000);
    expect(loans.single.dueDate, '2026-08-01');

    await repo.recordPayment(
        loan: loans.single, amountCents: 5000, paidOn: domain.day(2026, 7, 20));
    expect(await repo.outstandingOf(loans.single), 7000);

    // Not overdue on the due Saturday itself…
    expect(
        await repo.overdueLoans(cycle.id, asOf: domain.day(2026, 8, 1)), isEmpty);
    // …overdue from the Sunday after.
    final overdue =
        await repo.overdueLoans(cycle.id, asOf: domain.day(2026, 8, 2));
    expect(overdue.single.id, loanId);

    final newId = await repo.confirmRollover(cycle, overdue.single,
        asOf: domain.day(2026, 8, 20)); // confirmed late
    loans = await repo.loansOf(cycle.id);
    final child = loans.firstWhere((l) => l.id == newId);
    expect(child.principalCents, 7000);
    expect(child.owedCents, 8400);
    expect(child.loanDate, '2026-08-02'); // historical Sunday
    expect(child.dueDate, '2026-09-05');
    expect(child.parentLoanId, loanId);
    expect(loans.firstWhere((l) => l.id == loanId).status, 'rolled_over');
  });

  test('totals + end cycle share-out, invariants hold', () async {
    final (cycle, members) = await makeCycle();
    final mary = members.firstWhere((m) => m.name == 'Mary');

    // Two Saturdays of contributions from everyone: (3+2+1) x $10 x 2 = $120.
    for (final sat in [domain.day(2026, 2, 7), domain.day(2026, 2, 14)]) {
      for (final m in members) {
        await repo.tickContribution(cycle: cycle, member: m, saturday: sat);
      }
    }
    // Mary borrows $100, pays $50, rolls over to $84 owed.
    await repo.takeLoan(
        cycle: cycle,
        member: mary,
        principalCents: 10000,
        loanDate: domain.day(2026, 7, 1));
    var loan = (await repo.loansOf(cycle.id)).single;
    await repo.recordPayment(
        loan: loan, amountCents: 5000, paidOn: domain.day(2026, 7, 20));
    loan = (await repo.loansOf(cycle.id)).single;
    await repo.confirmRollover(cycle, loan, asOf: domain.day(2026, 8, 2));

    final t = await repo.totals(cycle.id);
    expect(t.cashOnHandCents, 12000 + 5000 - 10000); // 7000
    expect(t.receivablesCents, 8400);
    expect(t.poolValueCents, 15400);

    final so = await repo.endCycle(cycle, asOf: domain.day(2026, 8, 3));
    expect(so.potCents, 15400);
    expect(so.cashCents, 7000);
    final (_, lines) = (await repo.shareOutOf(cycle.id))!;
    expect(lines.fold(0, (s, l) => s + l.payoutCents), 7000);
    expect(lines.fold(0, (s, l) => s + l.shareCents), 15400);
    final maryLine = lines.firstWhere((l) => l.memberId == mary.id);
    expect(maryLine.multiplier, 3);
    expect(maryLine.shareCents, 7700); // 3/6 of 15400
    expect(maryLine.debtDeductedCents, 8400);
    expect(maryLine.payoutCents, -700); // negative balance (SPEC 5)

    // Cycle is archived; a new one can start.
    expect(await repo.activeCycle(), isNull);
    expect((await repo.endedCycles()).single.id, cycle.id);
  });

  test('payment exceeding outstanding is rejected at the repo layer', () async {
    final (cycle, members) = await makeCycle();
    await repo.takeLoan(
        cycle: cycle,
        member: members.first,
        principalCents: 10000,
        loanDate: domain.day(2026, 7, 1));
    final loan = (await repo.loansOf(cycle.id)).single;
    expect(
      () => repo.recordPayment(
          loan: loan, amountCents: 12001, paidOn: domain.day(2026, 7, 2)),
      throwsArgumentError,
    );
    // exact payoff closes the loan
    await repo.recordPayment(
        loan: loan, amountCents: 12000, paidOn: domain.day(2026, 7, 2));
    expect((await repo.loansOf(cycle.id)).single.status, 'paid');
  });
}
