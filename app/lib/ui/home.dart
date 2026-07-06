import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'member_detail.dart';
import 'contributions.dart';
import 'cycle_end.dart';
import 'loans.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cycle = app.cycle!;
    final totals = app.totals;
    final collecting = cycle.status == 'collecting';

    final thisSat = app.saturdaysSoFar().isEmpty
        ? null
        : app.saturdaysSoFar().last;
    final tickedCount = thisSat == null
        ? 0
        : app.members.where((m) => app.isTicked(m.id, thisSat)).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(cycle.name),
        actions: [
          IconButton(
            tooltip: 'Cycle settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CycleSettingsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: app.refresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            if (collecting)
              Card(
                color: kGoldContainer,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '📥 Collection time — weekly payments are finished. '
                    'Record loan repayments, then share out when everyone '
                    'has paid.',
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ),
            if (app.overdue.isNotEmpty)
              Card(
                color: kDangerContainer,
                child: ListTile(
                  leading: const Icon(Icons.warning_amber, color: kDanger),
                  title: Text(
                      '${app.overdue.length} loan${app.overdue.length == 1 ? '' : 's'} past the due Saturday'),
                  subtitle: const Text('Tap to review — record payments or roll over'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoansScreen())),
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: BigStat(
                            label: 'Cash in the box',
                            value: money(totals?.cashOnHandCents ?? 0)),
                      ),
                      VerticalDivider(
                          width: QSpace.x6,
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Expanded(
                        child: BigStat(
                            label: 'Pool with loans',
                            value: money(totals?.poolValueCents ?? 0),
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!collecting && thisSat != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available, size: 32),
                  title: Text('Saturday ${satDate(thisSat)}'),
                  subtitle: Text(
                      '$tickedCount of ${app.members.length} members paid'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContributionsScreen())),
                ),
              ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.request_quote, size: 32),
                title: const Text('Loans'),
                subtitle: Text(_loanSummary(app)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoansScreen())),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.grid_on, size: 32),
                title: const Text('Weekly payments'),
                subtitle: const Text('The Saturday book — tick who paid'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContributionsScreen())),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.groups, size: 32),
                title: const Text('Members'),
                subtitle: Text(
                    '${app.members.length} members · ${app.members.fold(0, (s, m) => s + m.multiplier)} shares'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showMembers(context, app),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _loanSummary(AppState app) {
    final active = app.loans.where((l) => l.status == 'active').toList();
    if (active.isEmpty) return 'No open loans';
    final owed =
        active.fold(0, (s, l) => s + (app.outstandingByLoan[l.id] ?? 0));
    return '${active.length} open · ${money(owed)} still owed';
  }

  void _showMembers(BuildContext context, AppState app) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        children: [
          for (final m in app.members)
            ListTile(
              leading: CircleAvatar(child: Text(m.name.characters.first)),
              title: Text(m.name),
              subtitle: Text(
                  '×${m.multiplier} — pays ${money(m.multiplier * app.cycle!.weeklyUnitCents)} each Saturday'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MemberDetailScreen(member: m)));
              },
            ),
        ],
      ),
    );
  }
}
