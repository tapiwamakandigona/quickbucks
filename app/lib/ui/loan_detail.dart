import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'loans.dart' show recordPayment;

/// Full detail screen for a single loan — payment history, rollover chain,
/// and a clear breakdown of principal → owed → paid → remaining.
class LoanDetailScreen extends StatelessWidget {
  final Loan loan;
  const LoanDetailScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Re-fetch loan from state in case it changed (payment recorded, etc.)
    final currentLoan =
        app.loans.where((l) => l.id == loan.id).firstOrNull ?? loan;
    final member = app.memberById(currentLoan.memberId);
    final out = app.outstandingByLoan[currentLoan.id] ?? 0;
    final isActive = currentLoan.status == 'active';
    final paid = currentLoan.owedCents - out;
    final progress = currentLoan.owedCents > 0
        ? paid / currentLoan.owedCents
        : 0.0;

    // Find parent/child in the rollover chain.
    final parent = currentLoan.parentLoanId != null
        ? app.loans.where((l) => l.id == currentLoan.parentLoanId).firstOrNull
        : null;
    final child = app.loans
        .where((l) => l.parentLoanId == currentLoan.id)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('${member.name}\'s loan')),
      floatingActionButton: isActive
          ? FloatingActionButton.extended(
              onPressed: () => recordPayment(context, currentLoan),
              icon: const Icon(Icons.payments),
              label: const Text('Record payment'),
            )
          : null,
      body: FutureBuilder<List<LoanPayment>>(
        future: app.repo.paymentRowsOf(currentLoan.id),
        builder: (context, snap) {
          final payments = snap.data ?? [];
          return ListView(
            padding: const EdgeInsets.only(bottom: 96, top: 4),
            children: [
              // ── Status + amount header ───────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isActive
                                ? Icons.hourglass_bottom
                                : currentLoan.status == 'paid'
                                    ? Icons.check_circle
                                    : Icons.autorenew,
                            size: 28,
                            color: isActive
                                ? null
                                : currentLoan.status == 'paid'
                                    ? Colors.green
                                    : kGold,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isActive
                                ? '${money(out)} still to pay'
                                : currentLoan.status == 'paid'
                                    ? 'Paid off'
                                    : 'Rolled over',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      if (isActive && currentLoan.owedCents > 0) ...[
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: QRadius.smAll,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 10,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${money(paid)} of ${money(currentLoan.owedCents)} paid',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Key facts ───────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _fact('Borrowed', money(currentLoan.principalCents)),
                      _fact('Owed (with 20%)', money(currentLoan.owedCents)),
                      _fact(
                        'Taken on',
                        prettyDate(fromIso(currentLoan.loanDate)),
                      ),
                      _fact(
                        'Due by',
                        'Saturday ${satDate(fromIso(currentLoan.dueDate))}',
                      ),
                      if (isActive)
                        _fact('Remaining', money(out),
                            bold: true,
                            color: out > 0 ? kDanger : Colors.green),
                    ],
                  ),
                ),
              ),

              // ── Rollover chain ──────────────────────────────
              if (parent != null || child != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rollover chain',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (parent != null)
                          _chainTile(
                            context,
                            label: 'Came from',
                            loan: parent,
                            app: app,
                          ),
                        _chainTile(
                          context,
                          label: 'This loan',
                          loan: currentLoan,
                          app: app,
                          isCurrent: true,
                        ),
                        if (child != null)
                          _chainTile(
                            context,
                            label: 'Rolled into',
                            loan: child,
                            app: app,
                          ),
                      ],
                    ),
                  ),
                ),

              // ── Payment history ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Payments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (payments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'No payments recorded yet.',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                )
              else
                for (final p in payments)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.payments, size: 28),
                      title: Text(money(p.amountCents)),
                      subtitle: Text(
                        'Paid on ${prettyDate(fromIso(p.paidOn))}',
                      ),
                      trailing: Text(
                        _isOnTimeBadge(currentLoan, fromIso(p.paidOn)),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !fromIso(p.paidOn)
                                  .isAfter(fromIso(currentLoan.dueDate))
                              ? Colors.green
                              : kDanger,
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  Widget _fact(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chainTile(
    BuildContext context, {
    required String label,
    required Loan loan,
    required AppState app,
    bool isCurrent = false,
  }) {
    final out = app.outstandingByLoan[loan.id] ?? 0;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isCurrent ? Icons.arrow_right : Icons.subdirectory_arrow_right,
        color: isCurrent ? kGold : null,
      ),
      title: Text(
        '$label: ${money(loan.principalCents)} → ${money(loan.owedCents)}',
        style: TextStyle(
          fontSize: 15,
          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      subtitle: Text(
        loan.status == 'active'
            ? '${prettyDate(fromIso(loan.loanDate))} · ${money(out)} remaining'
            : prettyDate(fromIso(loan.loanDate)),
      ),
      onTap: isCurrent
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoanDetailScreen(loan: loan),
                ),
              ),
    );
  }

  String _isOnTimeBadge(Loan loan, DateTime paidOn) {
    return !paidOn.isAfter(fromIso(loan.dueDate)) ? 'On time' : 'Late';
  }
}
