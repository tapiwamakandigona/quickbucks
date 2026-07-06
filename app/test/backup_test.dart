import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbucks/data/backup.dart' as backup;
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

  test('backup round-trip preserves every table', () async {
    final db = AppDb(NativeDatabase.memory());
    final repo = Repo(db);
    await repo.createCycle(
        name: 'R1',
        startDate: domain.day(2026, 2, 7),
        members: [MemberInput('Mary', 3), MemberInput('Jane', 2)]);
    final cycle = (await repo.activeCycle())!;
    final members = await repo.membersOf(cycle.id);
    await repo.tickContribution(
        cycle: cycle, member: members.first, saturday: domain.day(2026, 2, 7));
    await repo.takeLoan(
        cycle: cycle,
        member: members.first,
        principalCents: 10000,
        loanDate: domain.day(2026, 3, 4));
    final loan = (await repo.loansOf(cycle.id)).single;
    await repo.recordPayment(
        loan: loan, amountCents: 4000, paidOn: domain.day(2026, 3, 20));

    final json =
        backup.exportSnapshotJson(await backup.exportSnapshot(db));

    final db2 = AppDb(NativeDatabase.memory());
    await backup.importSnapshot(db2, json);
    final repo2 = Repo(db2);
    final cycle2 = (await repo2.activeCycle())!;
    expect(cycle2.id, cycle.id);
    expect((await repo2.membersOf(cycle2.id)).length, 2);
    expect((await repo2.contributionsOf(cycle2.id)).length, 1);
    final loan2 = (await repo2.loansOf(cycle2.id)).single;
    expect(await repo2.outstandingOf(loan2), 8000);
    await db.close();
    await db2.close();
  });

  test('garbage file is rejected, nothing imported', () async {
    final db = AppDb(NativeDatabase.memory());
    expect(() => backup.importSnapshot(db, 'not json'),
        throwsFormatException);
    expect(() => backup.importSnapshot(db, '{"app":"other"}'),
        throwsFormatException);
    await db.close();
  });
}
