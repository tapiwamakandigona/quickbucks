import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbucks/data/db.dart';
import 'package:quickbucks/data/repo.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:sqlite3/open.dart';

void main() {
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

  Future<(Repo, Cycle, Member)> seed() async {
    final db = AppDb(NativeDatabase.memory());
    final repo = Repo(db);
    await repo.createCycle(
        name: 'R', startDate: domain.day(2026, 2, 7),
        members: [MemberInput('Mary', 2)]);
    final cycle = (await repo.activeCycle())!;
    final member = (await repo.membersOf(cycle.id)).single;
    return (repo, cycle, member);
  }

  test('undo payment restores outstanding and reopens a closed loan',
      () async {
    final (repo, cycle, member) = await seed();
    await repo.takeLoan(
        cycle: cycle, member: member, principalCents: 10000,
        loanDate: domain.day(2026, 3, 4));
    var loan = (await repo.loansOf(cycle.id)).single;
    // Pay in full -> closes the loan.
    final payId = await repo.recordPayment(
        loan: loan, amountCents: 12000, paidOn: domain.day(2026, 3, 20));
    loan = (await repo.loansOf(cycle.id)).single;
    expect(loan.status, 'paid');
    // Undo -> active again, full amount owed.
    await repo.deletePayment(payId);
    loan = (await repo.loansOf(cycle.id)).single;
    expect(loan.status, 'active');
    expect(await repo.outstandingOf(loan), 12000);
  });

  test('undo payment refused after rollover', () async {
    final (repo, cycle, member) = await seed();
    await repo.takeLoan(
        cycle: cycle, member: member, principalCents: 10000,
        loanDate: domain.day(2026, 3, 4));
    var loan = (await repo.loansOf(cycle.id)).single;
    final payId = await repo.recordPayment(
        loan: loan, amountCents: 5000, paidOn: domain.day(2026, 4, 1));
    loan = (await repo.loansOf(cycle.id)).single;
    await repo.confirmRollover(cycle, loan);
    expect(() => repo.deletePayment(payId), throwsStateError);
  });

  test('undo loan only while untouched', () async {
    final (repo, cycle, member) = await seed();
    final id = await repo.takeLoan(
        cycle: cycle, member: member, principalCents: 10000,
        loanDate: domain.day(2026, 3, 4));
    await repo.deleteLoan(id);
    expect(await repo.loansOf(cycle.id), isEmpty);
    // With a payment -> refused.
    final id2 = await repo.takeLoan(
        cycle: cycle, member: member, principalCents: 10000,
        loanDate: domain.day(2026, 3, 4));
    final loan2 = (await repo.loansOf(cycle.id)).single;
    await repo.recordPayment(
        loan: loan2, amountCents: 1000, paidOn: domain.day(2026, 3, 20));
    expect(() => repo.deleteLoan(id2), throwsStateError);
    // Rollover child -> refused.
    final loan2b = (await repo.loansOf(cycle.id)).single;
    final childId = await repo.confirmRollover(cycle, loan2b);
    expect(() => repo.deleteLoan(childId), throwsStateError);
  });
}
