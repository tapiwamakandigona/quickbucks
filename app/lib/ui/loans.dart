import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../data/db.dart';
import '../data/repo.dart';
import '../state.dart';
import '../theme.dart';
import 'common.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final overdueIds = {for (final l in app.overdue) l.id};
    final active = app.loans
        .where((l) => l.status == 'active' && !overdueIds.contains(l.id))
        .toList();
    final closed = app.loans.where((l) => l.status != 'active').toList();

    final collecting = app.cycle!.status == 'collecting';
    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      // No new loans during the collection phase (owner, 2026-07-06).
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96, top: 8),
        children: [
          if (app.overdue.isNotEmpty) ...[
            _header(context, 'Past the due Saturday', color: kDanger),
            for (final l in app.overdue) _OverdueCard(loan: l),
          ],
          // Open loans, grouped by the Saturday they were given out
          // (SPEC 3.1: loans happen on Saturdays, so the book reads like
          // the group's actual meetings).
          ..._groupedBySaturday(context, active),
          if (app.overdue.isEmpty && active.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No open loans. Use "New loans" on a Saturday when '
                'members take money from the pool.',
                style: TextStyle(fontSize: 17, height: 1.4),
              ),
            ),
          if (closed.isNotEmpty) ...[
            _header(context, 'Finished loans'),
            for (final l in closed) _LoanTile(loan: l),
          ],
        ],
      ),
    );
  }

  List<Widget> _groupedBySaturday(BuildContext context, List<Loan> active) {
    if (active.isEmpty) return const [];
    // app.loans is already newest-first by loan date.
    final widgets = <Widget>[_header(context, 'Open loans')];
    String? currentDate;
    for (final l in active) {
      if (l.loanDate != currentDate) {
        currentDate = l.loanDate;
        final d = fromIso(l.loanDate);
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
            child: Text(
              // Rollover loans start on a Sunday; normal loans on a Saturday.
              prettyDate(d),
              style: QType.label.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
      widgets.add(_LoanTile(loan: l));
    }
    return widgets;
  }

  Widget _header(BuildContext context, String text, {Color? color}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
    ),
  );
}

class _LoanTile extends StatelessWidget {
  final Loan loan;
  const _LoanTile({required this.loan});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final member = app.memberById(loan.memberId);
    final out = app.outstandingByLoan[loan.id];
    final isActive = loan.status == 'active';
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(member.name.characters.first)),
        title: Text(
          '${member.name} — ${isActive ? '${money(out ?? 0)} to pay' : money(loan.owedCents)}',
        ),
        subtitle: Text(
          isActive
              ? 'Took ${money(loan.principalCents)} · pay back by Saturday ${satDate(fromIso(loan.dueDate))}'
              : loan.status == 'paid'
              ? 'Paid off ${loan.closedOn != null ? 'on ${prettyDate(fromIso(loan.closedOn!))}' : ''}'
              : 'Rolled over into a new loan',
        ),
        trailing: isActive ? const Icon(Icons.chevron_right) : null,
        onTap: isActive ? () => _recordPayment(context, loan) : null,
      ),
    );
  }
}

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
            Text(
              '${member.name} still owes ${money(out)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'This was due Saturday ${satDate(fromIso(loan.dueDate))}. '
              'If it was paid on time, record the payment. Otherwise the '
              'rest becomes a new loan: ${money(newOwed)} to pay by '
              'Saturday ${satDate(newDue)}.',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _recordPayment(context, loan),
                    child: const Text('Record payment'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
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
                    child: const Text('Roll over'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _recordPayment(BuildContext context, Loan loan) async {
  final app = context.read<AppState>();
  final member = app.memberById(loan.memberId);
  final out = app.outstandingByLoan[loan.id] ?? 0;
  final amountCtrl = TextEditingController();
  var paidOn = today();
  // Overdue loans: default the payment date to the due Saturday, since a
  // payment recorded now usually happened on/before then (SPEC 3.6).
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
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                      firstDate: DateTime(2015),
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
                // "Pay all" on a legacy balance may carry coins — accept the
                // exact remaining amount only.
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

/// The Saturday loans book (SPEC 3.1, owner 2026-07-07): loans are handed
/// out on Saturdays, so the treasurer picks the Saturday ONCE and enters
/// everybody who took money that day — then saves the whole page together.
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
                    initialValue: e.member,
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
    // Every started row must be complete and whole-dollar.
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
