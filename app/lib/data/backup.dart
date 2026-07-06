/// Local backup & restore: the entire ledger as one JSON file.
///
/// Backup = share a `.json` file (WhatsApp, Drive, email — her choice).
/// Restore = pick a backup file; replaces everything after a confirmation.
/// Cloud backup (Appwrite) is planned for v1.1 on top of this same snapshot.
library;

import 'dart:convert';
import 'dart:io';


import 'db.dart';

const backupVersion = 1;

Future<Map<String, dynamic>> exportSnapshot(AppDb db) async => {
      'app': 'quickbucks',
      'version': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'cycles': [
        for (final r in await db.select(db.cycles).get()) r.toJson()
      ],
      'members': [
        for (final r in await db.select(db.members).get()) r.toJson()
      ],
      'contributions': [
        for (final r in await db.select(db.contributions).get()) r.toJson()
      ],
      'loans': [for (final r in await db.select(db.loans).get()) r.toJson()],
      'loanPayments': [
        for (final r in await db.select(db.loanPayments).get()) r.toJson()
      ],
      'shareOuts': [
        for (final r in await db.select(db.shareOuts).get()) r.toJson()
      ],
      'shareOutLines': [
        for (final r in await db.select(db.shareOutLines).get()) r.toJson()
      ],
    };

String exportSnapshotJson(Map<String, dynamic> snapshot) =>
    const JsonEncoder.withIndent('  ').convert(snapshot);

/// Validates and imports a snapshot, REPLACING all current data.
/// Throws [FormatException] on anything suspicious — never half-imports.
Future<void> importSnapshot(AppDb db, String jsonText) async {
  final Map<String, dynamic> data;
  try {
    data = jsonDecode(jsonText) as Map<String, dynamic>;
  } catch (_) {
    throw const FormatException('This file is not a QuickBucks backup.');
  }
  if (data['app'] != 'quickbucks') {
    throw const FormatException('This file is not a QuickBucks backup.');
  }
  if (data['version'] is! int || (data['version'] as int) > backupVersion) {
    throw const FormatException(
        'This backup is from a newer QuickBucks. Update the app first.');
  }
  List<Map<String, dynamic>> rows(String key) => [
        for (final e in (data[key] as List? ?? []))
          (e as Map).cast<String, dynamic>()
      ];

  await db.transaction(() async {
    // Delete children before parents.
    await db.delete(db.shareOutLines).go();
    await db.delete(db.shareOuts).go();
    await db.delete(db.loanPayments).go();
    await db.delete(db.loans).go();
    await db.delete(db.contributions).go();
    await db.delete(db.members).go();
    await db.delete(db.cycles).go();

    for (final r in rows('cycles')) {
      await db.into(db.cycles).insert(Cycle.fromJson(r));
    }
    for (final r in rows('members')) {
      await db.into(db.members).insert(Member.fromJson(r));
    }
    for (final r in rows('contributions')) {
      await db.into(db.contributions).insert(Contribution.fromJson(r));
    }
    for (final r in rows('loans')) {
      await db.into(db.loans).insert(Loan.fromJson(r));
    }
    for (final r in rows('loanPayments')) {
      await db.into(db.loanPayments).insert(LoanPayment.fromJson(r));
    }
    for (final r in rows('shareOuts')) {
      await db.into(db.shareOuts).insert(ShareOut.fromJson(r));
    }
    for (final r in rows('shareOutLines')) {
      await db.into(db.shareOutLines).insert(ShareOutLine.fromJson(r));
    }
  });
}

// ── Automatic safety-net backups ────────────────────────────────────────────
// After every change the app quietly writes today's snapshot to its private
// documents folder and keeps the last [autoBackupKeep] days. This protects
// against mistakes and corruption (not phone loss — the shareable backup
// file is still the way to keep records outside the phone).

const autoBackupKeep = 7;
const autoBackupPrefix = 'quickbucks-auto-';

/// Writes (or overwrites) today's auto backup in [dir]; prunes old ones.
/// Returns the file written. Never throws — a failed safety net must not
/// break the actual bookkeeping (errors are reported to the caller as null).
Future<File?> writeAutoBackup(AppDb db, Directory dir) async {
  try {
    final snapshot = await exportSnapshot(db);
    final now = DateTime.now();
    final stamp = '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    final file = File('${dir.path}/$autoBackupPrefix$stamp.json');
    await file.writeAsString(exportSnapshotJson(snapshot));
    final old = listAutoBackups(dir).skip(autoBackupKeep);
    for (final f in old) {
      try {
        f.deleteSync();
      } catch (_) {}
    }
    return file;
  } catch (_) {
    return null;
  }
}

/// Auto backups in [dir], newest first.
List<File> listAutoBackups(Directory dir) {
  if (!dir.existsSync()) return [];
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) =>
          f.path.split(Platform.pathSeparator).last.startsWith(autoBackupPrefix) &&
          f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => b.path.compareTo(a.path));
  return files;
}
