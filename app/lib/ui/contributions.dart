import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state.dart';
import 'common.dart';

/// The Saturday book: pick a Saturday, tick who paid. Backfilling past
/// Saturdays is normal (catch-up, SPEC 7).
class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final saturdays = app.saturdaysSoFar().reversed.toList();
    if (saturdays.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weekly payments')),
        body: const Center(
            child: Text('No Saturdays in this cycle yet.',
                style: TextStyle(fontSize: 17))),
      );
    }
    final selected = _selected ?? saturdays.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly payments')),
      body: Column(
        children: [
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: saturdays.length,
              itemBuilder: (_, i) {
                final s = saturdays[i];
                final done = app.members
                    .every((m) => app.isTicked(m.id, s));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('${s.day}/${s.month}/${s.year}',
                        style: done
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                    selected: s == selected,
                    onSelected: (_) => setState(() => _selected = s),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Saturday ${satDate(selected)}',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final m in app.members)
                  CheckboxListTile(
                    value: app.isTicked(m.id, selected),
                    title: Text(m.name),
                    subtitle: Text(
                        '×${m.multiplier} — ${money(m.multiplier * app.cycle!.weeklyUnitCents)}'),
                    onChanged: (v) async {
                      final repo = app.repo;
                      try {
                        if (v == true) {
                          await repo.tickContribution(
                              cycle: app.cycle!,
                              member: m,
                              saturday: selected);
                          if (context.mounted) {
                            showUndoNote(context, '${m.name} ticked ✓',
                                () async {
                              await repo.untickContribution(m.id, selected);
                              await app.refresh();
                            });
                          }
                        } else {
                          final ok = await confirmAction(context,
                              title: 'Remove this payment?',
                              message:
                                  'Untick ${m.name} for ${prettyDate(selected)}?',
                              yes: 'Untick');
                          if (!ok) return;
                          await repo.untickContribution(m.id, selected);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showNote(context, 'Could not save: ${friendlyError(e)}', error: true);
                        }
                      }
                      await app.refresh();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
