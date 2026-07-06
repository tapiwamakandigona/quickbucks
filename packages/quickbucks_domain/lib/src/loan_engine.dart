/// Loan lifecycle engine (SPEC 3). Pure functions + immutable values; the
/// persistence layer maps these to/from the database.
library;

import 'dates.dart';
import 'money.dart';

enum LoanStatus { active, paid, rolledOver }

/// An immutable snapshot of one independent loan (SPEC 3.1: each loan is
/// fully separate, a member may hold many).
class Loan {
  final String id;
  final String memberId;
  final int principalCents;

  /// principal + flat interest, fixed at creation (SPEC 3.1).
  final int owedCents;
  final DateTime loanDate;

  /// Saturday on/after day 30 (SPEC 3.2). Derived, but carried on the value
  /// so callers never recompute it inconsistently.
  final DateTime dueDate;
  final LoanStatus status;

  /// Set when this loan was created by a rollover of another loan (SPEC 3.4).
  final String? parentLoanId;

  Loan({
    required this.id,
    required this.memberId,
    required this.principalCents,
    required this.loanDate,
    this.status = LoanStatus.active,
    this.parentLoanId,
    int? owedCents,
    DateTime? dueDate,
    int interestPercent = 20,
  })  : owedCents = owedCents ??
            owedFor(principalCents, interestPercent: interestPercent),
        dueDate = dueDate ?? dueDateFor(loanDate) {
    if (principalCents <= 0) {
      throw ArgumentError('principalCents must be > 0');
    }
  }

  Loan copyWith({LoanStatus? status}) => Loan(
        id: id,
        memberId: memberId,
        principalCents: principalCents,
        loanDate: loanDate,
        status: status ?? this.status,
        parentLoanId: parentLoanId,
        owedCents: owedCents,
        dueDate: dueDate,
      );
}

class LoanPayment {
  final String loanId;
  final int amountCents;
  final DateTime paidOn;

  LoanPayment({
    required this.loanId,
    required this.amountCents,
    required this.paidOn,
  }) {
    if (amountCents <= 0) throw ArgumentError('amountCents must be > 0');
  }
}

/// Outstanding balance of a loan given its recorded payments (never stored;
/// always derived — DATA_MODEL.md).
int outstanding(Loan loan, Iterable<LoanPayment> payments) {
  var owed = loan.owedCents;
  for (final p in payments) {
    if (p.loanId != loan.id) continue;
    owed -= p.amountCents;
  }
  if (owed < 0) {
    throw StateError('Payments on loan ${loan.id} exceed the amount owed');
  }
  return owed;
}

/// Validates a prospective payment (SPEC 3.3): any amount, any date, but it
/// may not exceed what is still outstanding.
void validatePayment(
    Loan loan, Iterable<LoanPayment> existing, int amountCents) {
  if (amountCents <= 0) {
    throw ArgumentError('Payment must be positive');
  }
  final out = outstanding(loan, existing);
  if (amountCents > out) {
    throw ArgumentError(
        'Payment of $amountCents exceeds outstanding balance of $out');
  }
}

/// A payment made on or before the due Saturday is on time — the due
/// Saturday itself included (SPEC 3.3/3.4).
bool isOnTime(Loan loan, DateTime paidOn) =>
    !dateOnly(paidOn).isAfter(loan.dueDate);

/// The result of rolling over a loan: the closed parent and the new child.
class RolloverResult {
  final Loan closedParent;
  final Loan newLoan;
  RolloverResult(this.closedParent, this.newLoan);
}

/// Rolls over [loan] (SPEC 3.4). Preconditions:
///  * [today] is on/after the Sunday following the due Saturday
///    (paying on the due Saturday itself is still on time), and
///  * there is an outstanding remainder.
///
/// The new loan's `loan_date` is ALWAYS the Sunday after the parent's due
/// Saturday — regardless of when the treasurer confirms the rollover
/// (SPEC 3.6) — with a fresh 20% and a due date per the standard rule.
RolloverResult rollover(
  Loan loan,
  Iterable<LoanPayment> payments,
  DateTime today, {
  required String newLoanId,
  int interestPercent = 20,
}) {
  if (loan.status != LoanStatus.active) {
    throw StateError('Only active loans can roll over');
  }
  if (!isRolloverEligible(loan.dueDate, today)) {
    throw StateError(
        'Loan is not overdue yet: due ${loan.dueDate}, today $today. '
        'Payments on the due Saturday are on time (SPEC 3.4).');
  }
  final remainder = outstanding(loan, payments);
  if (remainder == 0) {
    throw StateError('Loan is fully paid; nothing to roll over');
  }
  final newLoan = Loan(
    id: newLoanId,
    memberId: loan.memberId,
    principalCents: remainder,
    loanDate: sundayAfter(loan.dueDate),
    parentLoanId: loan.id,
    interestPercent: interestPercent,
  );
  return RolloverResult(loan.copyWith(status: LoanStatus.rolledOver), newLoan);
}
