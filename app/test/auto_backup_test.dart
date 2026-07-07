/// Auto-backup safety net: writes daily snapshots, prunes old ones, and a
/// snapshot restores the exact ledger.
library;

import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quickbucks/data/backup.dart';
import 'package:sqlite3/open.dart';

import 'support/seed.dart';

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
    'writeAutoBackup writes today, lists newest first, prunes extras',
    () async {
      final state = await seedAppState();
      final dir = Directory.systemTemp.createTempSync('qb_auto');
      addTearDown(() => dir.deleteSync(recursive: true));

      // Fake 9 old daily backups.
      for (var d = 1; d <= 9; d++) {
        File(
          '${dir.path}/${autoBackupPrefix}2026-06-${d.toString().padLeft(2, '0')}.json',
        ).writeAsStringSync('{}');
      }
      final written = await writeAutoBackup(state.repo.db, dir);
      expect(written, isNotNull);
      final files = listAutoBackups(dir);
      expect(files.length, autoBackupKeep);
      expect(files.first.path, written!.path); // today's is newest
      // Oldest were pruned.
      expect(files.any((f) => f.path.contains('2026-06-01')), isFalse);

      // Round-trip: restoring today's auto backup reproduces the ledger.
      final fresh = await seedAppState();
      await importSnapshot(fresh.repo.db, await written.readAsString());
      await fresh.refresh();
      expect(fresh.members.length, 10);
      expect(fresh.totals!.cashOnHandCents, 290000);
      expect(fresh.totals!.poolValueCents, 327000);
    },
  );
}
