/// Repository — the only place UI touches data. Every mutation goes through
/// the domain engine (`quickbucks_domain`) so SPEC rules cannot be bypassed.
library;

import 'package:drift/drift.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;
import 'package:uuid/uuid.dart';

import 'db.dart';

const _uuid = Uuid();

String iso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime fromIso(String s) {
  final p = s.split('-').map(int.parse).toList();
  return domain.day(p[0], p[1], p[2]);
}

/// Today as a calendar date (device local time → date only).
DateTime today() {
  final now = DateTime.now();
  return domain.day(now.year, now.month, now.day);
}

class MemberInput {
  final String name;
  final int multiplier;
  MemberInput(this.name, this.multiplier);
}

class Repo {
  final AppDb db;
  Repo(this.db);

  // ── Cycles ────────────────────────────────────────────────────────────────

  Stream<Cycle?> watchActiveCycle() => (db.select(db.cycles)
        ..where((c) => c.status.equals('active'))
        ..limit(1))
      .watchSingleOrNull();

  Future<Cycle?> activeCycle() => (db.select(db.cycles)
        ..where((c) => c.status.equals('active'))
        ..limit(1))
      .getSingleOrNull();

  Future<List<Cycle>> endedCycles() async => (db.select(db.cycles)
        ..where((c) => c.status.equals('ended'))
        ..orderBy([(c) => OrderingTerm.desc(c.startDate)]))
      .get();

  /// Creates a cycle. Start date may be in the past (catch-up, SPEC 7).
  /// Members + multipliers are locked in here (SPEC 1).
  Future<String> createCycle({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required List<MemberInput> members,
  }) async {
    if (members.isEmpty) throw ArgumentError('At least one member required');
    if (members.any((m) => m.multiplier < 1)) {
      throw ArgumentError('Multipliers must be 1 or more');
    }
    if (endDate != null && !endDate.isAfter(startDate)) {
      throw ArgumentError('End date must be after the start date');
    }
    if (await activeCycle() != null) {
      throw StateError('There is already an active cycle');
    }
    final cycleId = _uuid.v4();
    await db.transaction(() async {
      await db.into(db.cycles).insert(CyclesCompanion.insert(
            id: cycleId,
            name: name,
            startDate: iso(startDate),
            endDate: Value(endDate == null ? null : iso(endDate)),
          ));
      for (final m in members) {
        await db.into(db.members).insert(MembersCompanion.insert(
              id: _uuid.v4(),
              cycleId: cycleId,
              name: m.name.trim(),
              multiplier: m.multiplier,
            ));
      }
    });
    return cycleId;
  }

  Future<void> editEndDate(String cycleId, DateTime? endDate) async {
    final cycle = await (db.select(db.cycles)
          ..where((c) => c.id.equals(cycleId)))
        .getSingle();
    if (cycle.status != 'active') {
      throw StateError('Only the active cycle can be edited');
    }
    if (endDate != null && !endDate.isAfter(fromIso(cycle.startDate))) {
      throw ArgumentError('End date must be after the start date');
    }
    await (db.update(db.cycles)..where((c) => c.id.equals(cycleId))).write(
        CyclesCompanion(endDate: Value(endDate == null ? null : iso(endDate))));
  }

  Future<List<Member>> membersOf(String cycleId) => (db.select(db.members)
        ..where((m) => m.cycleId.equals(cycleId))
        ..orderBy([(m) => OrderingTerm.asc(m.name)]))
      .get();

  // ── Contributions (SPEC 2) ────────────────────────────────────────────────

  Future<void> tickContribution({
    required Cycle cycle,
    required Member member,
    required DateTime saturday,
  }) async {
    if (!domain.isSaturday(saturday)) {
      throw ArgumentError('Contributions are recorded for Saturdays');
    }
    await db.into(db.contributions).insert(ContributionsCompanion.insert(
          id: _uuid.v4(),
          cycleId: cycle.id,
          memberId: member.id,
          saturday: iso(saturday),
          amountCents: cycle.weeklyUnitCents * member.multiplier,
          recordedOn: iso(today()),
        ));
  }

  Future<void> untickContribution(String memberId, DateTime saturday) async {
    await (db.delete(db.contributions)
          ..where((c) =>
              c.memberId.equals(memberId) & c.saturday.equals(iso(saturday))))
        .go();
  }

  Future<List<Contribution>> contributionsOf(String cycleId) =>
      (db.select(db.contributions)..where((c) => c.cycleId.equals(cycleId)))
          .get();

  // ── Loans (SPEC 3) ────────────────────────────────────────────────────────

  domain.Loan toDomain(Loan l) => domain.Loan(
        id: l.id,
        memberId: l.memberId,
        principalCents: l.principalCents,
        loanDate: fromIso(l.loanDate),
        owedCents: l.owedCents,
        dueDate: fromIso(l.dueDate),
        status: switch (l.status) {
          'active' => domain.LoanStatus.active,
          'paid' => domain.LoanStatus.paid,
          _ => domain.LoanStatus.rolledOver,
        },
        parentLoanId: l.parentLoanId,
      );

  Future<List<domain.LoanPayment>> _paymentsOfLoan(String loanId) async {
    final rows = await (db.select(db.loanPayments)
          ..where((p) => p.loanId.equals(loanId)))
        .get();
    return [
      for (final r in rows)
        domain.LoanPayment(
            loanId: r.loanId,
            amountCents: r.amountCents,
            paidOn: fromIso(r.paidOn)),
    ];
  }

  /// Disburses a new loan. [loanDate] may be in the past (catch-up).
  Future<String> takeLoan({
    required Cycle cycle,
    required Member member,
    required int principalCents,
    required DateTime loanDate,
  }) async {
    final l = domain.Loan(
      id: _uuid.v4(),
      memberId: member.id,
      principalCents: principalCents,
      loanDate: loanDate,
      interestPercent: cycle.interestPct,
    );
    await db.into(db.loans).insert(LoansCompanion.insert(
          id: l.id,
          cycleId: cycle.id,
          memberId: member.id,
          principalCents: l.principalCents,
          owedCents: l.owedCents,
          loanDate: iso(l.loanDate),
          dueDate: iso(l.dueDate),
        ));
    return l.id;
  }

  /// Records a payment; closes the loan automatically when fully paid.
  Future<void> recordPayment({
    required Loan loan,
    required int amountCents,
    required DateTime paidOn,
  }) async {
    final dLoan = toDomain(loan);
    final existing = await _paymentsOfLoan(loan.id);
    domain.validatePayment(dLoan, existing, amountCents);
    await db.transaction(() async {
      await db.into(db.loanPayments).insert(LoanPaymentsCompanion.insert(
            id: _uuid.v4(),
            loanId: loan.id,
            amountCents: amountCents,
            paidOn: iso(paidOn),
            recordedOn: iso(today()),
          ));
      final remaining =
          domain.outstanding(dLoan, existing) - amountCents;
      if (remaining == 0) {
        await (db.update(db.loans)..where((l) => l.id.equals(loan.id))).write(
            LoansCompanion(
                status: const Value('paid'), closedOn: Value(iso(paidOn))));
      }
    });
  }

  Future<int> outstandingOf(Loan loan) async =>
      domain.outstanding(toDomain(loan), await _paymentsOfLoan(loan.id));

  /// Loans past their due Saturday (rollover-eligible) that are still active.
  /// Feeds the SPEC 3.6 prompt — the app never rolls these silently.
  Future<List<Loan>> overdueLoans(String cycleId, {DateTime? asOf}) async {
    final now = asOf ?? today();
    final rows = await (db.select(db.loans)
          ..where((l) => l.cycleId.equals(cycleId) & l.status.equals('active')))
        .get();
    return [
      for (final l in rows)
        if (domain.isRolloverEligible(fromIso(l.dueDate), now)) l
    ];
  }

  /// Confirms a rollover (SPEC 3.4/3.6). The new loan's date is the historical
  /// Sunday after the parent's due Saturday, regardless of confirmation time.
  Future<String> confirmRollover(Cycle cycle, Loan loan,
      {DateTime? asOf}) async {
    final result = domain.rollover(
      toDomain(loan),
      await _paymentsOfLoan(loan.id),
      asOf ?? today(),
      newLoanId: _uuid.v4(),
      interestPercent: cycle.interestPct,
    );
    await db.transaction(() async {
      await (db.update(db.loans)..where((l) => l.id.equals(loan.id))).write(
          LoansCompanion(
              status: const Value('rolled_over'),
              closedOn: Value(iso(result.newLoan.loanDate))));
      final n = result.newLoan;
      await db.into(db.loans).insert(LoansCompanion.insert(
            id: n.id,
            cycleId: cycle.id,
            memberId: n.memberId,
            principalCents: n.principalCents,
            owedCents: n.owedCents,
            loanDate: iso(n.loanDate),
            dueDate: iso(n.dueDate),
            parentLoanId: Value(n.parentLoanId),
          ));
    });
    return result.newLoan.id;
  }

  Future<List<Loan>> loansOf(String cycleId) => (db.select(db.loans)
        ..where((l) => l.cycleId.equals(cycleId))
        ..orderBy([(l) => OrderingTerm.desc(l.loanDate)]))
      .get();

  // ── Totals (SPEC 4) ──────────────────────────────────────────────────────

  Future<domain.LedgerTotals> totals(String cycleId) async {
    final contribs = await contributionsOf(cycleId);
    final loans = await loansOf(cycleId);
    final loanIds = {for (final l in loans) l.id};
    final payments = await (db.select(db.loanPayments)
          ..where((p) => p.loanId.isIn(loanIds)))
        .get();
    final shareOut = await (db.select(db.shareOuts)
          ..where((s) => s.cycleId.equals(cycleId)))
        .getSingleOrNull();
    var payouts = <int>[];
    if (shareOut != null) {
      final lines = await (db.select(db.shareOutLines)
            ..where((l) => l.shareOutId.equals(shareOut.id)))
          .get();
      // Only positive payouts are cash handed out.
      payouts = [
        for (final l in lines)
          if (l.payoutCents > 0) l.payoutCents
      ];
    }
    return domain.computeTotals(
      contributionAmounts: contribs.map((c) => c.amountCents),
      loans: loans.map(toDomain),
      payments: [
        for (final p in payments)
          domain.LoanPayment(
              loanId: p.loanId,
              amountCents: p.amountCents,
              paidOn: fromIso(p.paidOn)),
      ],
      payoutAmounts: payouts,
    );
  }

  // ── End cycle & share-out (SPEC 5) ───────────────────────────────────────

  /// Ends the cycle now and computes+persists the share-out.
  /// Fails if any loan is still overdue-unconfirmed? No — outstanding loans
  /// are settled against shares per SPEC 5; overdue prompts should be
  /// resolved first in the UI flow, but math works either way.
  Future<ShareOut> endCycle(Cycle cycle, {DateTime? asOf}) async {
    final now = asOf ?? today();
    final members = await membersOf(cycle.id);
    final loans = await loansOf(cycle.id);
    final t = await totals(cycle.id);

    final outstandingByMember = <String, int>{};
    for (final l in loans) {
      if (l.status != 'active') continue;
      outstandingByMember[l.memberId] =
          (outstandingByMember[l.memberId] ?? 0) + await outstandingOf(l);
    }
    final result = domain.computeShareOut(
      cashCents: t.cashOnHandCents,
      multipliers: {for (final m in members) m.id: m.multiplier},
      outstandingByMember: outstandingByMember,
    );

    final shareOutId = _uuid.v4();
    await db.transaction(() async {
      await db.into(db.shareOuts).insert(ShareOutsCompanion.insert(
            id: shareOutId,
            cycleId: cycle.id,
            potCents: result.potCents,
            cashCents: result.cashCents,
            createdOn: iso(now),
          ));
      for (final line in result.lines) {
        await db.into(db.shareOutLines).insert(ShareOutLinesCompanion.insert(
              id: _uuid.v4(),
              shareOutId: shareOutId,
              memberId: line.memberId,
              multiplier: line.multiplier,
              shareCents: line.shareCents,
              debtDeductedCents: line.debtDeductedCents,
              payoutCents: line.payoutCents,
            ));
      }
      // Settle active loans: they are absorbed into the share-out.
      await (db.update(db.loans)
            ..where((l) => l.cycleId.equals(cycle.id) & l.status.equals('active')))
          .write(LoansCompanion(
              status: const Value('paid'), closedOn: Value(iso(now))));
      await (db.update(db.cycles)..where((c) => c.id.equals(cycle.id))).write(
          CyclesCompanion(
              status: const Value('ended'),
              endedOn: Value(iso(now)),
              endDate: Value(iso(now))));
    });
    return (db.select(db.shareOuts)..where((s) => s.id.equals(shareOutId)))
        .getSingle();
  }

  Future<(ShareOut, List<ShareOutLine>)?> shareOutOf(String cycleId) async {
    final so = await (db.select(db.shareOuts)
          ..where((s) => s.cycleId.equals(cycleId)))
        .getSingleOrNull();
    if (so == null) return null;
    final lines = await (db.select(db.shareOutLines)
          ..where((l) => l.shareOutId.equals(so.id)))
        .get();
    return (so, lines);
  }
}
