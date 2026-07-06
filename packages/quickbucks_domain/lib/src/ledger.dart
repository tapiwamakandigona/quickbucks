/// Accounting identities (SPEC 4).
///
/// cash_on_hand = Σ contributions + Σ repayments − Σ principals out − Σ payouts
/// receivables  = Σ outstanding owed on active loans (includes the 20%)
/// pool_value   = cash_on_hand + receivables
library;

import 'loan_engine.dart';

class LedgerTotals {
  final int cashOnHandCents;
  final int receivablesCents;
  int get poolValueCents => cashOnHandCents + receivablesCents;
  LedgerTotals({required this.cashOnHandCents, required this.receivablesCents});
}

LedgerTotals computeTotals({
  required Iterable<int> contributionAmounts,
  required Iterable<Loan> loans, // all loans of the cycle, any status
  required Iterable<LoanPayment> payments,
  Iterable<int> payoutAmounts = const [], // positive payouts already handed out
}) {
  final contributions = contributionAmounts.fold(0, (a, b) => a + b);
  final repayments = payments.fold(0, (a, b) => a + b.amountCents);
  // Rolled-over loans never disbursed new cash — only count real disbursements.
  final principalsOut = loans
      .where((l) => l.parentLoanId == null)
      .fold(0, (a, l) => a + l.principalCents);
  final payouts = payoutAmounts.fold(0, (a, b) => a + b);
  final cash = contributions + repayments - principalsOut - payouts;

  var receivables = 0;
  for (final l in loans) {
    if (l.status != LoanStatus.active) continue;
    receivables += outstanding(l, payments);
  }
  return LedgerTotals(cashOnHandCents: cash, receivablesCents: receivables);
}
