import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';
import 'loan_detail.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  bool _groupByMember = true; // default to member view (U2)

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final overdueIds = {for (final l in app.overdue) l.id};
    final active = app.loans
        .where((l) => l.status == 'active' && !overdueIds.contains(l.id))
        .toList();
    final closed = app.loans.where((l) => l.status != 'active').toList();
    final openCount = app.overdue.length + active.length;

    final collecting = app.cycle!.status == 'collecting';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loans'),
          actions: [
            // Toggle between member and date grouping (U2).
            IconButton(
              tooltip: _groupByMember ? 'Group by date' : 'Group by member',
              icon: Icon(
                _groupByMember ? Icons.calendar_month : Icons.people,
              ),
              onPressed: () =>
                  setState(() => _groupByMember = !_groupByMember),
            ),
          ],
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontSize: 17),
            tabs: [
              Tab(text: 'To pay${openCount > 0 ? ' ($openCount)' : ''}'),
              Tab(
                text: 'Paid${closed.isNotEmpty ? ' (${closed.length})' : ''}',
              ),
            ],
          ),
        ),
        floatingActionButton: collecting
            ? null
            : FloatingActionButton.extended(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const SaturdayLoansScreen(),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New loans'),
              ),
        body: TabBarView(
          children: [
            _openTab(context, app, active),
            _paidTab(context, closed),
          ],
        ),
      ),
    );
  }

  Widget _openTab(BuildContext context, AppState app, List<Loan> active) {
    if (app.overdue.isEmpty && active.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No open loans. Use "New loans" on a Saturday when '
          'members take money from the pool.',
          style: TextStyle(fontSize: 17, height: 1.4),
        ),
      );
    }

    // Total outstanding across all open loans (U5).
    final allOpen = [...app.overdue, ...active];
    final totalOwed = allOpen.fold(
      0,
      (s, l) => s + (app.outstandingByLoan[l.id] ?? 0),
    );

    return ListView(
      padding: const EdgeInsets.only(bottom: 96, top: 4),
      children: [
        // ── Total header (U5) ─────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${allOpen.length} open ${allOpen.length == 1 ? 'loan' : 'loans'}',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              Text(
                '${money(totalOwed)} still owed',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 16, endIndent: 16),

        if (app.overdue.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              'Past the due Saturday',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: kDanger),
            ),
          ),
          for (final l in app.overdue) _OverdueCard(loan: l),
          if (active.isNotEmpty) const SizedBox(height: 8),
        ],

        // Open loans: grouped by member (default) or by date.
        if (_groupByMember)
          ..._groupedByMember(context, active, app)
        else
          ..._groupedBySaturday(context, active),
      ],
    );
  }

  Widget _paidTab(BuildContext context, List<Loan> closed) {
    if (closed.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Nothing here yet. Loans that are fully paid off (or rolled '
          'over) move to this page.',
          style: TextStyle(fontSize: 17, height: 1.4),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 96, top: 4),
      children: _groupByMember
          ? _groupedByMember(context, closed, context.watch<AppState>(),
              paid: true)
          : _groupedBySaturday(context, closed, paid: true),
    );
  }

  List<Widget> _groupedBySaturday(
    BuildContext context,
    List<Loan> loans, {
    bool paid = false,
  }) {
    if (loans.isEmpty) return const [];
    final widgets = <Widget>[];
    String? currentDate;
    for (final l in loans) {
      if (l.loanDate != currentDate) {
        currentDate = l.loanDate;
        final sameDay = loans.where((x) => x.loanDate == currentDate).toList();
        widgets.add(_SaturdayBanner(date: fromIso(l.loanDate), loans: sameDay));
      }
      widgets.add(_LoanTile(loan: l));
    }
    return widgets;
  }

  /// Group loans by member (U2): shows a member header + their loans below.
  List<Widget> _groupedByMember(
    BuildContext context,
    List<Loan> loans,
    AppState app, {
    bool paid = false,
  }) {
    if (loans.isEmpty) return const [];
    // Group by memberId, preserving order of first occurrence.
    final byMember = <String, List<Loan>>{};
    for (final l in loans) {
      byMember.putIfAbsent(l.memberId, () => []).add(l);
    }
    final widgets = <Widget>[];
    for (final entry in byMember.entries) {
      final member = app.memberById(entry.key);
      final memberLoans = entry.value;
      final totalOut = memberLoans.fold(
        0,
        (s, l) => s + (app.outstandingByLoan[l.id] ?? 0),
      );
      widgets.add(_MemberBanner(
        member: member,
        loanCount: memberLoans.length,
        totalOutstanding: totalOut,
        isPaid: paid,
      ));
      for (final l in memberLoans) {
        widgets.add(_LoanTile(loan: l));
      }
    }
    return widgets;
  }
}

/// Member group header for the member-grouped view (U2).
class _MemberBanner extends StatelessWidget {
  final Member member;
  final int loanCount;
  final int totalOutstanding;
  final bool isPaid;
  const _MemberBanner({
    required this.member,
    required this.loanCount,
    required this.totalOutstanding,
    this.isPaid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kGoldContainer,
        borderRadius: QRadius.mdAll,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Text(member.name.characters.first),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              member.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: kInk,
              ),
            ),
          ),
          Text(
            isPaid
                ? '$loanCount ${loanCount == 1 ? 'loan' : 'loans'}'
                : '$loanCount ${loanCount == 1 ? 'loan' : 'loans'} · ${money(totalOutstanding)}',
            style: const TextStyle(fontSize: 15, color: kInk),
          ),
        ],
      ),
    );
  }
}

/// A bold banner that opens each Saturday's group of loans.
class _SaturdayBanner extends StatelessWidget {
  final DateTime date;
  final List<Loan> loans;
  const _SaturdayBanner({required this.date, required this.loans});

  @override
  Widget build(BuildContext context) {
    final total = loans.fold(0, (s, l) => s + l.principalCents);
    final isSat = date.weekday == DateTime.saturday;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kGoldContainer,
        borderRadius: QRadius.mdAll,
      ),
      child: Row(
        children: [
          const Icon(Icons.event, size: 22, color: kInk),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              // N5: consistent format — always "Saturday {date}" or "Sunday {date}".
              isSat
                  ? 'Saturday ${satDate(date)}'
                  : 'Sunday ${satDate(date)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: kInk,
              ),
            ),
          ),
          Text(
            '${loans.length} ${loans.length == 1 ? 'loan' : 'loans'} · ${money(total)}',
            style: const TextStyle(fontSize: 15, color: kInk),
          ),
        ],
      ),
    );
  }
}

class _LoanTile extends StatelessWidget {
  final Loan loan;
  const _LoanTile({required this.loan});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final member = app.memberById(loan.memberId);
    final out = app.outstandingByLoan[loan.id] ?? 0;
    final isActive = loan.status == 'active';
    final paid = loan.owedCents - out;
    final progress =
        isActive && loan.owedCents > 0 ? paid / loan.owedCents : 0.0;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    child: Text(member.name.characters.first),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isActive
                              ? '${money(out)} to pay · due ${shortDate(fromIso(loan.dueDate))}'
                              : loan.status == 'paid'
                                  ? 'Paid off${loan.closedOn != null ? ' ${shortDate(fromIso(loan.closedOn!))}' : ''}'
                                  : 'Rolled over into a new loan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Text(
                      money(out),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  else
                    Icon(
                      loan.status == 'paid'
                          ? Icons.check_circle
                          : Icons.autorenew,
                      color:
                          loan.status == 'paid' ? Colors.green : kGold,
                    ),
                ],
              ),
              // U4: progress bar for active loans.
              if (isActive && loan.owedCents > 0) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: QRadius.smAll,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${money(paid)} of ${money(loan.owedCents)} paid',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Simplified overdue card (U3): bold key numbers, clear actions, less text.
class _OverdueCard extends StatelessWidget {
  final Loan loan;
  const _OverdueCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final member = app.memberById(loan.memberId);
    final out = app.outstandingByLoan[loan.id] ?? 0;
    final newOwed = domain.owedFor(
      out,
      interestPercent: app.cycle!.interestPct,
    );
    final sunday = domain.sundayAfter(fromIso(loan.dueDate));
    final newDue = domain.dueDateFor(sunday);
    return Card(
      color: kDanger.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold headline with name + amount (U3 simplified).
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: kDanger.withValues(alpha: 0.12),
                  child: Text(
                    member.name.characters.first,
                    style: const TextStyle(
                      color: kDanger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Due ${shortDate(fromIso(loan.dueDate))} · owes ${money(out)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: kDanger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  money(out),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kDanger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Two clear action cards instead of a paragraph of text.
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => recordPayment(context, loan),
                    icon: const Icon(Icons.payments, size: 20),
                    label: const Text('She paid'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: kDanger,
                    ),
                    onPressed: () async {
                      final ok = await confirmAction(
                        context,
                        title: 'Roll over this loan?',
                        message:
                            '${member.name}\'s unpaid ${money(out)} becomes a '
                            'new loan from Sunday ${prettyDate(sunday)}.\n\n'
                            'They will owe ${money(newOwed)} (20% added), due '
                            'Saturday ${satDate(newDue)}.',
                        yes: 'Roll over',
                      );
                      if (!ok || !context.mounted) return;
                      try {
                        await app.repo.confirmRollover(app.cycle!, loan);
                        await app.refresh();
                        if (context.mounted) {
                          showNote(context, 'Rolled over ✓');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showNote(
                            context,
                            'Could not roll over: ${friendlyError(e)}',
                            error: true,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.autorenew, size: 20),
                    label: const Text('Roll over'),
                  ),
                ),
              ],
            ),
            // Collapsed detail text — tap to expand.
            const SizedBox(height: 8),
            Text(
              'If not paid → new loan: ${money(newOwed)} by Sat ${shortDate(newDue)}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Record a payment against a loan. Extracted as a top-level function so
/// [LoanDetailScreen] can call it too.
Future<void> recordPayment(BuildContext context, Loan loan) async {
  final app = context.read<AppState>();
  final member = app.memberById(loan.memberId);
  final out = app.outstandingByLoan[loan.id] ?? 0;
  final amountCtrl = TextEditingController();
  var paidOn = today();
  final due = fromIso(loan.dueDate);
  final overdue = today().isAfter(due);
  if (overdue) paidOn = due;

  String? sheetError;
  final result = await showModalBottomSheet<(int, DateTime)>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${member.name} pays back',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            Text(
              'Still to pay: ${money(out)}',
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (whole US\$)',
                suffixIcon: TextButton(
                  onPressed: () => amountCtrl.text = out % 100 == 0
                      ? (out ~/ 100).toString()
                      : (out / 100).toStringAsFixed(2),
                  child: const Text('Pay all'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('Paid on', style: Theme.of(ctx).textTheme.titleSmall),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (overdue)
                  ChoiceChip(
                    label: Text(
                      'Due Saturday · ${shortDate(due)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    selected: paidOn == due,
                    onSelected: (_) => setSheet(() => paidOn = due),
                  ),
                ChoiceChip(
                  label: Text(
                    'Today · ${shortDate(today())}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  selected: paidOn == today(),
                  onSelected: (_) => setSheet(() => paidOn = today()),
                ),
                if (paidOn != today() && (!overdue || paidOn != due))
                  ChoiceChip(
                    label: Text(
                      prettyDate(paidOn),
                      style: const TextStyle(fontSize: 16),
                    ),
                    selected: true,
                    onSelected: (_) {},
                  ),
                ActionChip(
                  avatar: const Icon(Icons.edit_calendar, size: 20),
                  label: const Text(
                    'Another day',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: paidOn,
                      firstDate: fromIso(loan.loanDate),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) {
                      setSheet(
                        () => paidOn = domain.day(d.year, d.month, d.day),
                      );
                    }
                  },
                ),
              ],
            ),
            if (sheetError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  sheetError!,
                  style: const TextStyle(
                    color: kDanger,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                var cents = parseUsdToCents(amountCtrl.text);
                if (cents == null &&
                    amountCtrl.text.trim() == (out / 100).toStringAsFixed(2)) {
                  cents = out;
                }
                if (cents == null || cents <= 0 || cents > out) {
                  setSheet(
                    () => sheetError = cents == null || cents <= 0
                        ? 'Enter whole dollars, like 20'
                        : 'That is more than the ${money(out)} owed',
                  );
                  return;
                }
                Navigator.pop(ctx, (cents, paidOn));
              },
              child: const Text('Record payment'),
            ),
          ],
        ),
      ),
    ),
  );
  if (result == null || !context.mounted) return;
  final (cents, date) = result;
  final ok = await confirmAction(
    context,
    title: 'Record this payment?',
    message:
        '${member.name} paid ${money(cents)} on ${prettyDate(date)}.\n\n'
        '${cents == out ? 'This pays the loan off completely. 🎉' : 'They will still owe ${money(out - cents)} (due date stays the same).'}',
  );
  if (!ok || !context.mounted) return;
  try {
    final paymentId = await app.repo.recordPayment(
      loan: loan,
      amountCents: cents,
      paidOn: date,
    );
    await app.refresh();
    if (context.mounted) {
      showUndoNote(context, 'Payment recorded ✓', () async {
        await app.repo.deletePayment(paymentId);
        await app.refresh();
      });
    }
  } catch (e) {
    if (context.mounted) {
      showNote(context, 'Could not save: ${friendlyError(e)}', error: true);
    }
  }
}

/// One row of the Saturday loans book: who + how much.
class _LoanEntry {
  Member? member;
  final TextEditingController amount = TextEditingController();
  void dispose() => amount.dispose();
}

/// The Saturday loans book (SPEC 3.1).
class SaturdayLoansScreen extends StatefulWidget {
  const SaturdayLoansScreen({super.key});

  @override
  State<SaturdayLoansScreen> createState() => _SaturdayLoansScreenState();
}

class _SaturdayLoansScreenState extends State<SaturdayLoansScreen> {
  DateTime? _saturday;
  final List<_LoanEntry> _entries = [_LoanEntry()];
  String? _error;

  @override
  void initState() {
    super.initState();
    final sats = context.read<AppState>().saturdaysSoFar();
    if (sats.isNotEmpty) _saturday = sats.last;
    for (final e in _entries) {
      e.amount.addListener(_clearError);
    }
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  List<(Member, int)> _validEntries() => [
    for (final e in _entries)
      if (e.member != null)
        if (parseUsdToCents(e.amount.text) case final int c when c > 0)
          (e.member!, c),
  ];

  int get _totalCents => _validEntries().fold(0, (sum, e) => sum + e.$2);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final valid = _validEntries();
    return Scaffold(
      appBar: AppBar(title: const Text('Saturday loans')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Text(
            '1 · Which Saturday?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          const Text(
            'Loans are given out on Saturdays.',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          SaturdayChips(
            saturdays: app.saturdaysSoFar(),
            selected: _saturday,
            onChanged: (s) => setState(() => _saturday = s),
          ),
          const SizedBox(height: 24),
          Text(
            '2 · Who took money?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < _entries.length; i++) _entryCard(context, app, i),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              final e = _LoanEntry();
              e.amount.addListener(_clearError);
              _entries.add(e);
            }),
            icon: const Icon(Icons.person_add),
            label: const Text('Add another member'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: kDanger,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => _saveAll(context),
            child: Text(
              valid.isEmpty
                  ? 'Save loans'
                  : 'Save ${valid.length} ${valid.length == 1 ? 'loan' : 'loans'} · ${money(_totalCents)}',
            ),
          ),
        ),
      ),
    );
  }

  Widget _entryCard(BuildContext context, AppState app, int i) {
    final e = _entries[i];
    final cents = parseUsdToCents(e.amount.text);
    final preview =
        (e.member != null && cents != null && cents > 0 && _saturday != null)
        ? '${e.member!.name} will owe ${money(domain.owedFor(cents, interestPercent: app.cycle!.interestPct))} by ${prettyDate(domain.dueDateFor(_saturday!))}'
        : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Member>(
                    value: e.member,
                    decoration: const InputDecoration(labelText: 'Who?'),
                    items: [
                      for (final m in app.members)
                        DropdownMenuItem(value: m, child: Text(m.name)),
                    ],
                    onChanged: (m) => setState(() => e.member = m),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: e.amount,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'US\$',
                      hintText: '20',
                    ),
                  ),
                ),
                if (_entries.length > 1)
                  IconButton(
                    tooltip: 'Remove this row',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _entries.removeAt(i).dispose();
                    }),
                  ),
              ],
            ),
            if (preview != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10, right: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kGoldContainer,
                  borderRadius: QRadius.mdAll,
                ),
                child: Text(
                  preview,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAll(BuildContext context) async {
    final app = context.read<AppState>();
    if (_saturday == null) {
      setState(() => _error = 'Pick the Saturday first');
      return;
    }
    for (final e in _entries) {
      final started = e.member != null || e.amount.text.trim().isNotEmpty;
      if (!started) continue;
      if (e.member == null) {
        setState(() => _error = 'Choose a member for every row');
        return;
      }
      final cents = parseUsdToCents(e.amount.text);
      if (cents == null || cents <= 0) {
        setState(
          () => _error = 'Enter whole dollars for ${e.member!.name}, like 20',
        );
        return;
      }
    }
    final entries = _validEntries();
    if (entries.isEmpty) {
      setState(() => _error = 'Add at least one loan');
      return;
    }
    // N2: warn on duplicate members in the same batch.
    final memberIds = entries.map((e) => e.$1.id).toList();
    final uniqueIds = memberIds.toSet();
    if (uniqueIds.length < memberIds.length) {
      final dupes = <String>{};
      final seen = <String>{};
      for (final id in memberIds) {
        if (!seen.add(id)) dupes.add(app.memberById(id).name);
      }
      final ok = await confirmAction(
        context,
        title: '${dupes.join(', ')} appears more than once',
        message:
            'The same member has multiple loans in this batch. '
            'Each becomes a separate loan. Is that right?',
        yes: 'Yes, continue',
      );
      if (!ok || !context.mounted) return;
    }
    final lines = [
      for (final (m, c) in entries)
        '• ${m.name}: ${money(c)} → owes ${money(domain.owedFor(c, interestPercent: app.cycle!.interestPct))} by Sat ${satDate(domain.dueDateFor(_saturday!))}',
    ].join('\n');
    final ok = await confirmAction(
      context,
      title:
          'Give out ${entries.length == 1 ? 'this loan' : 'these ${entries.length} loans'}?',
      message:
          'Saturday ${satDate(_saturday!)} — ${money(_totalCents)} leaves the box.\n\n$lines',
      yes: 'Give ${entries.length == 1 ? 'loan' : 'loans'}',
    );
    if (!ok || !context.mounted) return;
    try {
      final ids = await app.repo.takeLoanBatch(
        cycle: app.cycle!,
        saturday: _saturday!,
        entries: entries,
      );
      await app.refresh();
      if (!context.mounted) return;
      Navigator.pop(context);
      showUndoNote(
        context,
        '${ids.length} ${ids.length == 1 ? 'loan' : 'loans'} recorded ✓',
        () async {
          for (final id in ids) {
            await app.repo.deleteLoan(id);
          }
          await app.refresh();
        },
      );
    } catch (e) {
      setState(() => _error = 'Could not save: ${friendlyError(e)}');
    }
  }
}
