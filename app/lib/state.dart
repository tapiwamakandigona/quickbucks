import 'package:flutter/foundation.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import 'data/db.dart';
import 'data/repo.dart';

/// App-wide state: the active cycle and everything derived from it.
/// Screens call [refresh] after mutations; all math lives in Repo/domain.
class AppState extends ChangeNotifier {
  final Repo repo;
  AppState(this.repo);

  bool loading = true;
  Cycle? cycle;
  List<Member> members = [];
  List<Contribution> contributions = [];
  List<Loan> loans = [];
  Map<String, int> outstandingByLoan = {};
  List<Loan> overdue = [];
  domain.LedgerTotals? totals;
  List<Cycle> archived = [];

  Member memberById(String id) => members.firstWhere((m) => m.id == id);

  Future<void> refresh() async {
    cycle = await repo.activeCycle();
    archived = await repo.endedCycles();
    if (cycle != null) {
      members = await repo.membersOf(cycle!.id);
      contributions = await repo.contributionsOf(cycle!.id);
      loans = await repo.loansOf(cycle!.id);
      outstandingByLoan = {
        for (final l in loans)
          if (l.status == 'active') l.id: await repo.outstandingOf(l)
      };
      overdue = await repo.overdueLoans(cycle!.id);
      totals = await repo.totals(cycle!.id);
    } else {
      members = [];
      contributions = [];
      loans = [];
      outstandingByLoan = {};
      overdue = [];
      totals = null;
    }
    loading = false;
    notifyListeners();
  }

  /// Saturdays of the active cycle so far (start → today, capped at end date).
  List<DateTime> saturdaysSoFar() {
    if (cycle == null) return [];
    final start = fromIso(cycle!.startDate);
    var end = today();
    if (cycle!.endDate != null) {
      final e = fromIso(cycle!.endDate!);
      if (e.isBefore(end)) end = e;
    }
    return domain.saturdaysBetween(start, end);
  }

  bool isTicked(String memberId, DateTime saturday) => contributions.any(
      (c) => c.memberId == memberId && c.saturday == iso(saturday));
}
