import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';
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
      if (context.mounted) showNote(context, 'Could not update: $e', error: true);
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
      if (context.mounted) showNote(context, 'Could not end: $e', error: true);
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
        showNote(context, 'Could not share out: $e', error: true);
      }
    }
  }
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
                padding: const EdgeInsets.all(20),
                child: FilledButton.icon(
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
