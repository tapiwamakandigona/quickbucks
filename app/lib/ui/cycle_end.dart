import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:share_plus/share_plus.dart';

import '../data/backup.dart' as backup;
import '../data/db.dart';
import '../data/repo.dart';
import '../data/reminder.dart' as reminder;
import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'lock.dart';
import 'reports.dart';

class CycleSettingsScreen extends StatelessWidget {
  const CycleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cycle = app.cycle;

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle & records')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          if (cycle != null) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Start date'),
                    subtitle: Text(prettyDate(fromIso(cycle.startDate))),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () => _editDate(context, isStart: true),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(cycle.status == 'collecting'
                        ? 'Weekly payments ended on'
                        : 'End date'),
                    subtitle: Text(cycle.endDate == null
                        ? 'Not set'
                        : prettyDate(fromIso(cycle.endDate!))),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () => _editDate(context, isStart: false),
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, size: 32),
                title: const Text('Export PDF record'),
                subtitle: const Text('All payments, loans and totals'),
                onTap: () => exportCyclePdf(context, cycle),
              ),
            ),
            if (cycle.status == 'active')
              Card(
                child: ListTile(
                  leading: const Icon(Icons.flag, size: 32, color: kGold),
                  title: const Text('End weekly payments'),
                  subtitle: const Text(
                      'Stops the Saturday book. Loan repayments continue '
                      'until you share out.'),
                  onTap: () => _endContributions(context),
                ),
              ),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.celebration, size: 32, color: kGold),
                title: const Text('Share out now'),
                subtitle: const Text(
                    'Split the pool by shares and finish this cycle'),
                onTap: () => _shareOut(context),
              ),
            ),
          ],
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.save_alt, size: 32),
                title: const Text('Back up my records'),
                subtitle: const Text(
                    'Saves everything to a file you can keep anywhere safe'),
                onTap: () => _backup(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings_backup_restore, size: 32),
                title: const Text('Restore from a backup'),
                subtitle:
                    const Text('Replaces what is on this phone with the file'),
                onTap: () => _restore(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.history, size: 32),
                title: const Text('Automatic backups'),
                subtitle: const Text(
                    'The app saves a copy by itself every day it is used'),
                onTap: () => _restoreAuto(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.password, size: 32),
                title: const Text('App PIN'),
                subtitle: const Text('Lock QuickBucks with a secret number'),
                onTap: () => managePin(context),
              ),
              const Divider(height: 1),
              const _SaturdayReminderTile(),
            ]),
          ),
          if (app.archived.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text('Finished cycles',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final c in app.archived)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2, size: 30),
                  title: Text(c.name),
                  subtitle: Text(
                      '${prettyDate(fromIso(c.startDate))} → ${c.endedOn == null ? '' : prettyDate(fromIso(c.endedOn!))}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ShareOutSheetScreen(cycle: c))),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _editDate(BuildContext context, {required bool isStart}) async {
    final app = context.read<AppState>();
    final cycle = app.cycle!;
    final current = isStart
        ? fromIso(cycle.startDate)
        : (cycle.endDate == null ? today() : fromIso(cycle.endDate!));
    final d = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: DateTime(2015),
        lastDate: DateTime(2040));
    if (d == null || !context.mounted) return;
    final date = domain.day(d.year, d.month, d.day);
    try {
      if (isStart) {
        await app.repo.editStartDate(cycle.id, date);
      } else {
        await app.repo.editEndDate(cycle.id, date);
      }
      await app.refresh();
      if (context.mounted) showNote(context, 'Date updated ✓');
    } catch (e) {
      if (context.mounted) showNote(context, 'Could not update: ${friendlyError(e)}', error: true);
    }
  }

  Future<void> _endContributions(BuildContext context) async {
    final app = context.read<AppState>();
    final ok = await confirmAction(
      context,
      title: 'End weekly payments?',
      message: 'No more Saturday payments will be collected. Members keep '
          'paying back their loans, and you can "Share out" whenever '
          'everyone is ready.\n\nYou can still change dates afterwards.',
      yes: 'End weekly payments',
    );
    if (!ok || !context.mounted) return;
    try {
      await app.repo.endContributions(app.cycle!);
      await app.refresh();
      if (context.mounted) showNote(context, 'Weekly payments ended ✓');
    } catch (e) {
      if (context.mounted) showNote(context, 'Could not end: ${friendlyError(e)}', error: true);
    }
  }

  Future<void> _shareOut(BuildContext context) async {
    final app = context.read<AppState>();
    final cycle = app.cycle!;
    final t = app.totals!;
    final openDebts = t.receivablesCents;
    final ok = await confirmAction(
      context,
      title: 'Share out and finish the cycle?',
      message: 'Cash in the box: ${money(t.cashOnHandCents)}\n'
          '${openDebts > 0 ? 'Still owed by members: ${money(openDebts)} — this will be taken off their shares.\n' : 'All loans are paid. 🎉\n'}'
          'Pot to share: ${money(t.poolValueCents)}\n\n'
          'This finishes the cycle for good. The record stays saved and '
          'you can export the PDF any time.',
      yes: 'Share out',
    );
    if (!ok || !context.mounted) return;
    try {
      await app.repo.endCycle(cycle);
      await app.refresh();
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ShareOutSheetScreen(cycle: cycle)));
      }
    } catch (e) {
      if (context.mounted) {
        showNote(context, 'Could not share out: ${friendlyError(e)}', error: true);
      }
    }
  }
}

Future<void> _backup(BuildContext context) async {
  final app = context.read<AppState>();
  try {
    final snapshot = await backup.exportSnapshot(app.repo.db);
    final json = backup.exportSnapshotJson(snapshot);
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/QuickBucks backup ${iso(today())}.json');
    await file.writeAsString(json);
    await Share.shareXFiles([XFile(file.path)],
        text: 'QuickBucks backup — keep this file safe.');
  } catch (e) {
    if (context.mounted) {
      showNote(context, 'Could not make the backup: ${friendlyError(e)}', error: true);
    }
  }
}

Future<void> _restore(BuildContext context) async {
  final app = context.read<AppState>();
  final picked = await FilePicker.platform
      .pickFiles(type: FileType.any, withData: true);
  final data = picked?.files.single.bytes;
  if (data == null || !context.mounted) return;
  final ok = await confirmAction(
    context,
    title: 'Restore from this backup?',
    message: 'Everything currently in the app will be REPLACED by the '
        'backup file. This cannot be undone.\n\n'
        'Only continue if this is the right file.',
    yes: 'Replace everything',
  );
  if (!ok || !context.mounted) return;
  try {
    await backup.importSnapshot(app.repo.db, utf8.decode(data));
    await app.refresh();
    if (context.mounted) {
      showNote(context, 'Backup restored ✓');
      Navigator.popUntil(context, (r) => r.isFirst);
    }
  } catch (e) {
    if (context.mounted) {
      showNote(context, 'Restore failed — nothing was changed: ${friendlyError(e)}',
          error: true);
    }
  }
}

/// Lists the automatic daily backups and restores the chosen one.
Future<void> _restoreAuto(BuildContext context) async {
  final app = context.read<AppState>();
  final dir = app.autoBackupDir;
  final files = dir == null ? <File>[] : backup.listAutoBackups(dir);
  if (files.isEmpty) {
    showNote(context, 'No automatic backups yet — use the app once and one '
        'will be saved.');
    return;
  }
  final chosen = await showModalBottomSheet<File>(
    context: context,
    showDragHandle: true,
    builder: (sheetCtx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text('Go back to an earlier day',
              style: Theme.of(sheetCtx).textTheme.titleLarge),
        ),
        for (final f in files)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(_autoBackupLabel(f)),
            onTap: () => Navigator.pop(sheetCtx, f),
          ),
        const SizedBox(height: 12),
      ]),
    ),
  );
  if (chosen == null || !context.mounted) return;
  final ok = await confirmAction(
    context,
    title: 'Go back to ${_autoBackupLabel(chosen)}?',
    message: 'Everything currently in the app will be REPLACED by that '
        'day\'s copy. Changes made after it will be lost.',
    yes: 'Replace everything',
  );
  if (!ok || !context.mounted) return;
  try {
    await backup.importSnapshot(app.repo.db, await chosen.readAsString());
    await app.refresh();
    if (context.mounted) {
      showNote(context, 'Backup restored ✓');
      Navigator.popUntil(context, (r) => r.isFirst);
    }
  } catch (e) {
    if (context.mounted) {
      showNote(context,
          'Restore failed — nothing was changed: ${friendlyError(e)}',
          error: true);
    }
  }
}

/// 'quickbucks-auto-2026-07-06.json' -> 'Mon, 6 Jul 2026'.
String _autoBackupLabel(File f) {
  final name = f.path.split(Platform.pathSeparator).last;
  final m = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(name);
  if (m == null) return name;
  return prettyDate(DateTime(
      int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!)));
}

/// Plain-text share-out summary, ready for the group's WhatsApp chat.
String _shareOutText(Cycle cycle, ShareOut shareOut, List<ShareOutLine> lines,
    String Function(String) nameOf) {
  final b = StringBuffer()
    ..writeln('🎉 ${cycle.name} — share-out')
    ..writeln('Pot: ${money(shareOut.potCents)}')
    ..writeln('');
  for (final l in lines) {
    b.write('${nameOf(l.memberId)} (×${l.multiplier}): '
        '${money(l.shareCents)}');
    if (l.debtDeductedCents > 0) {
      b.write(' − ${money(l.debtDeductedCents)} owed');
    }
    b.writeln(' → ${money(l.payoutCents)}');
  }
  b
    ..writeln('')
    ..writeln('Cash paid out: ${money(shareOut.cashCents)}')
    ..writeln('Made with QuickBucks');
  return b.toString();
}

/// The final balance sheet of a finished cycle.
class ShareOutSheetScreen extends StatelessWidget {
  final Cycle cycle;
  const ShareOutSheetScreen({super.key, required this.cycle});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text('${cycle.name} — share-out')),
      body: FutureBuilder(
        future: Future.wait([
          app.repo.shareOutOf(cycle.id),
          app.repo.membersOf(cycle.id),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final so = snap.data![0] as (ShareOut, List<ShareOutLine>)?;
          final members = snap.data![1] as List<Member>;
          if (so == null) {
            return const Center(
                child: Text('No share-out recorded for this cycle.',
                    style: TextStyle(fontSize: 17)));
          }
          final (shareOut, lines) = so;
          String nameOf(String id) =>
              members.firstWhere((m) => m.id == id).name;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    Expanded(
                        child: BigStat(
                            label: 'Pot shared',
                            value: money(shareOut.potCents),
                            color: kGold)),
                    Expanded(
                        child: BigStat(
                            label: 'Cash paid out',
                            value: money(shareOut.cashCents))),
                  ]),
                ),
              ),
              for (final l in lines)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Text(nameOf(l.memberId).characters.first)),
                    title: Text(nameOf(l.memberId)),
                    subtitle: Text(
                        'Share ×${l.multiplier}: ${money(l.shareCents)}'
                        '${l.debtDeductedCents > 0 ? ' − owed ${money(l.debtDeductedCents)}' : ''}'),
                    trailing: Text(
                      money(l.payoutCents),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color:
                              l.payoutCents < 0 ? kDanger : Colors.black87),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: FilledButton.icon(
                  onPressed: () => Share.share(_shareOutText(
                      cycle, shareOut, lines, nameOf)),
                  icon: const Icon(Icons.chat),
                  label: const Text('Send as message (WhatsApp)'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: FilledButton.tonalIcon(
                  onPressed: () => exportShareOutSlips(context, cycle),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Print slips — one per member'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton.icon(
                  onPressed: () => exportCyclePdf(context, cycle),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF record'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Toggle for the weekly Saturday-morning notification.
class _SaturdayReminderTile extends StatefulWidget {
  const _SaturdayReminderTile();

  @override
  State<_SaturdayReminderTile> createState() => _SaturdayReminderTileState();
}

class _SaturdayReminderTileState extends State<_SaturdayReminderTile> {
  bool? _on;

  @override
  void initState() {
    super.initState();
    reminder.reminderEnabled().then((v) {
      if (mounted) setState(() => _on = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_active, size: 32),
      title: const Text('Saturday reminder'),
      subtitle: const Text('A note every Saturday at 8:00 to open the book'),
      value: _on ?? false,
      onChanged: _on == null
          ? null
          : (v) async {
              final messenger = ScaffoldMessenger.of(context);
              final ok = await reminder.setReminder(v);
              if (!mounted) return;
              if (!ok) {
                messenger.showSnackBar(const SnackBar(
                    content: Text('The phone did not allow notifications. '
                        'Allow them for QuickBucks in phone Settings.')));
              }
              setState(() => _on = v && ok);
            },
    );
  }
}
