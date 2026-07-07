import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'reports.dart';

/// One member's full story: weekly payments, loans, and (after share-out)
/// her payout — plus a shareable PDF statement to show at the market.
class MemberDetailScreen extends StatelessWidget {
  final Member member;
  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cycle = app.cycle!;
    final saturdays = app.saturdaysSoFar();
    final paid = [
      for (final s in saturdays)
        if (app.isTicked(member.id, s)) s,
    ];
    final missed = [
      for (final s in saturdays)
        if (!app.isTicked(member.id, s)) s,
    ];
    final weekly = member.multiplier * cycle.weeklyUnitCents;
    final loans = app.loans.where((l) => l.memberId == member.id).toList();
    final owed = loans
        .where((l) => l.status == 'active')
        .fold(0, (s, l) => s + (app.outstandingByLoan[l.id] ?? 0));

    return Scaffold(
      appBar: AppBar(title: Text(member.name)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: BigStat(
                      label: 'Saved so far',
                      value: money(paid.length * weekly),
                    ),
                  ),
                  Expanded(
                    child: BigStat(
                      label: 'Still owes',
                      value: money(owed),
                      color: owed > 0 ? kDanger : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_available, size: 32),
              title: Text(
                'Paid ${paid.length} of ${saturdays.length} Saturdays',
              ),
              subtitle: Text(
                missed.isEmpty
                    ? 'Not a single one missed!'
                    : 'Missing: ${missed.map((s) => prettyDate(s)).join(', ')}',
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.savings, size: 32),
              title: Text('×${member.multiplier} multiplier'),
              subtitle: Text('${money(weekly)} every Saturday'),
            ),
          ),
          if (loans.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                'Loans',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final l in loans)
              Card(
                child: ListTile(
                  leading: Icon(
                    l.status == 'active'
                        ? Icons.hourglass_bottom
                        : l.status == 'paid'
                        ? Icons.check_circle
                        : Icons.autorenew,
                    size: 32,
                    color: l.status == 'paid' ? Colors.green : null,
                  ),
                  title: Text(
                    l.status == 'active'
                        ? '${money(app.outstandingByLoan[l.id] ?? 0)} still to pay'
                        : l.status == 'paid'
                        ? '${money(l.owedCents)} — paid off'
                        : '${money(l.owedCents)} — rolled over',
                  ),
                  subtitle: Text(
                    'Took ${money(l.principalCents)} on ${prettyDate(fromIso(l.loanDate))} · owed ${money(l.owedCents)} by ${prettyDate(fromIso(l.dueDate))}',
                  ),
                ),
              ),
          ],
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton.icon(
              onPressed: () => exportMemberPdf(context, member),
              icon: const Icon(Icons.picture_as_pdf),
              label: Text('Share ${member.name}\'s statement'),
            ),
          ),
        ],
      ),
    );
  }
}
