import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'loan_detail.dart';
import 'reports.dart';

/// One member's full story: weekly payments, loans with payment history,
/// and (after share-out) her payout — plus a shareable PDF statement.
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
            for (final l in loans) _LoanCardWithPayments(loan: l),
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

/// Loan card that shows payment rows inline (M6) and navigates to the
/// loan detail screen on tap. Rolled-over loans show a link (M5).
class _LoanCardWithPayments extends StatelessWidget {
  final Loan loan;
  const _LoanCardWithPayments({required this.loan});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isActive = loan.status == 'active';
    final out = app.outstandingByLoan[loan.id] ?? 0;
    final child = app.loans
        .where((l) => l.parentLoanId == loan.id)
        .firstOrNull;

    return Card(
      child: InkWell(
        borderRadius: QRadius.mdAll,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoanDetailScreen(loan: loan),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive
                        ? Icons.hourglass_bottom
                        : loan.status == 'paid'
                            ? Icons.check_circle
                            : Icons.autorenew,
                    size: 28,
                    color: loan.status == 'paid' ? Colors.green : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isActive
                              ? '${money(out)} still to pay'
                              : loan.status == 'paid'
                                  ? '${money(loan.owedCents)} — paid off'
                                  : '${money(loan.owedCents)} — rolled over',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Took ${money(loan.principalCents)} on '
                          '${prettyDate(fromIso(loan.loanDate))} · '
                          'owed ${money(loan.owedCents)} by '
                          '${prettyDate(fromIso(loan.dueDate))}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              // M6: inline payment history.
              FutureBuilder<List<LoanPayment>>(
                future: app.repo.paymentRowsOf(loan.id),
                builder: (context, snap) {
                  final payments = snap.data ?? [];
                  if (payments.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, left: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final p in payments)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${money(p.amountCents)} paid ${shortDate(fromIso(p.paidOn))}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              // M5: link to child loan if rolled over.
              if (loan.status == 'rolled_over' && child != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 38),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoanDetailScreen(loan: child),
                      ),
                    ),
                    child: Text(
                      'See new loan → ${money(child.owedCents)} due ${shortDate(fromIso(child.dueDate))}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
