/// v1 → v2 migration: stored loan due dates were computed with the old
/// "+30 days" rule; upgrading must recompute them with the corrected
/// "same date next month" rule (SPEC 3.2, owner correction 2026-07-06).
library;

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

  test(
    'upgrading from v1 recomputes loan due dates with the month rule',
    () async {
      final dir = await Directory.systemTemp.createTemp('qb_migration');
      final file = File('${dir.path}/qb.sqlite');

      // ── Set up a "v1" database: real schema, old-rule due date, version 1 ──
      {
        final db = AppDb(NativeDatabase(file));
        final repo = Repo(db);
        await repo.createCycle(
          name: 'Savings 2026',
          startDate: domain.day(2026, 2, 7),
          members: [MemberInput('Mary', 2)],
        );
        final cycle = (await repo.activeCycle())!;
        final mary = (await repo.membersOf(cycle.id)).single;
        // Loan Sat 2026-07-11. Old rule: +30d = Mon 10 Aug → Sat 15 Aug.
        // New rule: 11 Aug (Tue) → due Sat 15 Aug.
        await repo.takeLoan(
          cycle: cycle,
          member: mary,
          principalCents: 10000,
          loanDate: domain.day(2026, 7, 11),
        );
        // Force the old-rule value + old schema version on disk.
        await db.customStatement("UPDATE loans SET due_date = '2026-08-08'");
        await db.customStatement('PRAGMA user_version = 1');
        await db.close();
      }

      // ── Reopen: drift sees 1 → 3 and must run the recompute migrations ──
      {
        final db = AppDb(NativeDatabase(file));
        final loan = (await db.select(db.loans).get()).single;
        expect(loan.dueDate, '2026-08-15');
        await db.close();
      }

      await dir.delete(recursive: true);
    },
  );
}
