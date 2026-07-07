/// Shared realistic seed: the real cycle shape (10 members, Feb 7 - Jun 20
/// 2026, Mary's spec-example loan + Grace's open loan). Used by the golden
/// screenshot harness and the PDF render harness.
library;

import 'package:drift/native.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart';
import 'package:quickbucks/state.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

Future<AppState> seedAppState() async {
  final db = AppDb(NativeDatabase.memory());
  final repo = Repo(db);
  final names = [
    ('Susan', 3),
    ('Mary', 2),
    ('Grace', 2),
    ('Blessing', 1),
    ('Patience', 1),
    ('Comfort', 2),
    ('Esther', 1),
    ('Joyce', 1),
    ('Ruth', 2),
    ('Naomi', 1),
  ];
  await repo.createCycle(
    name: 'Savings 2026',
    startDate: domain.day(2026, 2, 7),
    members: [for (final (n, m) in names) MemberInput(n, m)],
  );
  final cycle = (await repo.activeCycle())!;
  await repo.editEndDate(cycle.id, domain.day(2026, 6, 20));
  final members = await repo.membersOf(cycle.id);
  // Contributions: everyone paid every Saturday Feb 7 – Jun 20.
  final sats = domain.saturdaysBetween(
    domain.day(2026, 2, 7),
    domain.day(2026, 6, 20),
  );
  for (final m in members) {
    for (final s in sats) {
      await repo.tickContribution(cycle: cycle, member: m, saturday: s);
    }
  }
  // Loans: Mary's story + one more outstanding loan.
  final mary = members.firstWhere((m) => m.name == 'Mary');
  final grace = members.firstWhere((m) => m.name == 'Grace');
  await repo.takeLoan(
    cycle: cycle,
    member: mary,
    principalCents: 10000,
    loanDate: domain.day(2026, 5, 9),
  ); // Saturday (SPEC 3.1)
  final maryLoan = (await repo.loansOf(cycle.id)).single;
  await repo.recordPayment(
    loan: maryLoan,
    amountCents: 5000,
    paidOn: domain.day(2026, 5, 20),
  );
  await repo.takeLoan(
    cycle: cycle,
    member: grace,
    principalCents: 25000,
    loanDate: domain.day(2026, 6, 6),
  ); // Saturday (SPEC 3.1)
  final state = AppState(repo);
  await state.refresh();
  return state;
}
