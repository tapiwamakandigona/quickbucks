import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('SPEC 3.5 — the confirmed worked example (Mary), verbatim', () {
    test('borrow \$100 on Wed 2026-07-01, pay \$50, roll over \$70 -> \$84',
        () {
      // Mary borrows $100 on Wed 2026-07-01 → owes $120, due Sat 2026-08-01.
      final loan = Loan(
        id: 'L1',
        memberId: 'mary',
        principalCents: 10000,
        loanDate: day(2026, 7, 1),
      );
      expect(loan.owedCents, 12000);
      expect(loan.dueDate, day(2026, 8, 1));

      // She pays $50 on 2026-07-20 → owes $70, same due date, no new interest.
      final p1 = LoanPayment(
          loanId: 'L1', amountCents: 5000, paidOn: day(2026, 7, 20));
      expect(outstanding(loan, [p1]), 7000);
      expect(isOnTime(loan, p1.paidOn), isTrue);

      // Due Saturday passes with $70 unpaid → on Sun 2026-08-02 a new loan:
      // owes $84 ($70 + 20%), due Sat 2026-09-05.
      final result = rollover(loan, [p1], day(2026, 8, 2), newLoanId: 'L2');
      expect(result.closedParent.status, LoanStatus.rolledOver);
      expect(result.newLoan.principalCents, 7000);
      expect(result.newLoan.owedCents, 8400);
      expect(result.newLoan.loanDate, day(2026, 8, 2)); // the Sunday after
      expect(result.newLoan.dueDate, day(2026, 9, 5));
      expect(result.newLoan.parentLoanId, 'L1');
    });
  });

  group('payments (SPEC 3.3)', () {
    final loan = Loan(
        id: 'L1',
        memberId: 'm',
        principalCents: 10000,
        loanDate: day(2026, 7, 1));

    test('paying ON the due Saturday is on time', () {
      expect(isOnTime(loan, day(2026, 8, 1)), isTrue);
      expect(isOnTime(loan, day(2026, 8, 2)), isFalse);
    });
    test('payment cannot exceed outstanding', () {
      expect(() => validatePayment(loan, [], 12001), throwsArgumentError);
      validatePayment(loan, [], 12000); // exact payoff OK
    });
    test('overpayment across multiple payments is rejected', () {
      final p = LoanPayment(
          loanId: 'L1', amountCents: 11000, paidOn: day(2026, 7, 10));
      expect(() => validatePayment(loan, [p], 1001), throwsArgumentError);
      validatePayment(loan, [p], 1000);
    });
    test('payments to other loans are ignored in outstanding', () {
      final other = LoanPayment(
          loanId: 'OTHER', amountCents: 9999, paidOn: day(2026, 7, 10));
      expect(outstanding(loan, [other]), 12000);
    });
  });

  group('rollover guards (SPEC 3.4)', () {
    final loan = Loan(
        id: 'L1',
        memberId: 'm',
        principalCents: 10000,
        loanDate: day(2026, 7, 1)); // due 2026-08-01

    test('cannot roll over on the due Saturday itself', () {
      expect(() => rollover(loan, [], day(2026, 8, 1), newLoanId: 'L2'),
          throwsStateError);
    });
    test('cannot roll over a fully paid loan', () {
      final paid = LoanPayment(
          loanId: 'L1', amountCents: 12000, paidOn: day(2026, 7, 30));
      expect(() => rollover(loan, [paid], day(2026, 8, 2), newLoanId: 'L2'),
          throwsStateError);
    });
    test('cannot roll over a non-active loan', () {
      final closed = loan.copyWith(status: LoanStatus.rolledOver);
      expect(() => rollover(closed, [], day(2026, 8, 2), newLoanId: 'L2'),
          throwsStateError);
    });
    test(
        'confirming late does not shift dates: effective loan_date is still '
        'the historical Sunday (SPEC 3.6 / catch-up SPEC 7)', () {
      // Treasurer only confirms on 2026-08-20; dates must be as if on 08-02.
      final r = rollover(loan, [], day(2026, 8, 20), newLoanId: 'L2');
      expect(r.newLoan.loanDate, day(2026, 8, 2));
      expect(r.newLoan.dueDate, day(2026, 9, 5));
    });
  });

  group('rollover chains repeat indefinitely (SPEC 3.4)', () {
    test('two consecutive rollovers compound 20% each time', () {
      final l1 = Loan(
          id: 'L1',
          memberId: 'm',
          principalCents: 10000,
          loanDate: day(2026, 7, 1)); // owes 12000, due 08-01
      final r1 = rollover(l1, [], day(2026, 8, 2), newLoanId: 'L2');
      // L2: principal 12000, owes 14400, loan_date Sun 08-02, due Sat 09-05.
      expect(r1.newLoan.owedCents, 14400);
      expect(r1.newLoan.dueDate, day(2026, 9, 5));

      final r2 = rollover(r1.newLoan, [], day(2026, 9, 6), newLoanId: 'L3');
      // L3: principal 14400, owes 17280, loan_date Sun 09-06, due:
      // day30 = Tue 10-06 -> Sat 2026-10-10.
      expect(r2.newLoan.principalCents, 14400);
      expect(r2.newLoan.owedCents, 17280);
      expect(r2.newLoan.loanDate, day(2026, 9, 6));
      expect(r2.newLoan.dueDate, day(2026, 10, 10));
      expect(r2.newLoan.parentLoanId, 'L2');
    });
  });
}
