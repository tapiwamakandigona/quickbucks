import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('computeTotals (SPEC 4)', () {
    test('full scenario incl. rollover: rollovers disburse no new cash', () {
      // 3 members, multipliers 1/2/3 -> $10/$20/$30 per Saturday; 2 Saturdays.
      final contributions = [1000, 2000, 3000, 1000, 2000, 3000]; // $120 total
      final l1 = Loan(
          id: 'L1',
          memberId: 'mary',
          principalCents: 10000,
          loanDate: day(2026, 7, 1)); // $100 out, owes $120
      final p1 = LoanPayment(
          loanId: 'L1', amountCents: 5000, paidOn: day(2026, 7, 20));
      final r = rollover(l1, [p1], day(2026, 8, 2), newLoanId: 'L2');

      final totals = computeTotals(
        contributionAmounts: contributions,
        loans: [r.closedParent, r.newLoan],
        payments: [p1],
      );
      // cash = 12000 (contribs) + 5000 (repayment) - 10000 (L1 disbursed) = 7000
      expect(totals.cashOnHandCents, 7000);
      // receivables = only L2 active: owes 8400
      expect(totals.receivablesCents, 8400);
      expect(totals.poolValueCents, 15400);
    });

    test('payouts reduce cash', () {
      final totals = computeTotals(
        contributionAmounts: [10000],
        loans: [],
        payments: [],
        payoutAmounts: [4000],
      );
      expect(totals.cashOnHandCents, 6000);
      expect(totals.poolValueCents, 6000);
    });

    test('paid-off loans leave no receivable', () {
      final l1 = Loan(
          id: 'L1',
          memberId: 'm',
          principalCents: 10000,
          loanDate: day(2026, 7, 1));
      final payoff = LoanPayment(
          loanId: 'L1', amountCents: 12000, paidOn: day(2026, 7, 30));
      final totals = computeTotals(
        contributionAmounts: [20000],
        loans: [l1.copyWith(status: LoanStatus.paid)],
        payments: [payoff],
      );
      // cash = 20000 + 12000 - 10000 = 22000; group earned $20 interest.
      expect(totals.cashOnHandCents, 22000);
      expect(totals.receivablesCents, 0);
    });
  });
}
