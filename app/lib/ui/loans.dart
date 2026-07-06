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
    final closed =
        app.loans.where((l) => l.status != 'active').toList();

    final collecting = app.cycle!.status == 'collecting';
    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      // No new loans during the collection phase (owner, 2026-07-06).
      floatingActionButton: collecting
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _takeLoan(context),
              icon: const Icon(Icons.add),
              label: const Text('New loan'),
            ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96, top: 8),
        children: [
          if (app.overdue.isNotEmpty) ...[
            _header(context, '⚠️ Past the due Saturday'),
            for (final l in app.overdue) _OverdueCard(loan: l),
          ],
          if (active.isNotEmpty) ...[
            _header(context, 'Open loans'),
            for (final l in active) _LoanTile(loan: l),
          ],
          if (app.overdue.isEmpty && active.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No open loans. Use "New loan" when a member '
                  'takes money from the pool.',
                  style: TextStyle(fontSize: 17, height: 1.4)),
            ),
          if (closed.isNotEmpty) ...[
            _header(context, 'Finished loans'),
            for (final l in closed) _LoanTile(loan: l),
          ],
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Text(text, style: Theme.of(context).textTheme.titleLarge),
      );

  Future<void> _takeLoan(BuildContext context) async {
    final app = context.read<AppState>();
    final result = await showModalBottomSheet<(Member, int, DateTime)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _TakeLoanSheet(members: app.members),
    );
    if (result == null || !context.mounted) return;
    final (member, cents, date) = result;
    final owed = domain.owedFor(cents, interestPercent: app.cycle!.interestPct);
    final due = domain.dueDateFor(date);
    final ok = await confirmAction(
      context,
      title: 'Give out this loan?',
      message: '${member.name} takes ${money(cents)} on ${prettyDate(date)}.\n\n'
          'They will owe ${money(owed)} (20% added), '
          'to pay back by Saturday ${satDate(due)}.',
      yes: 'Give loan',
    );
    if (!ok || !context.mounted) return;
    try {
      await app.repo.takeLoan(
          cycle: app.cycle!,
          member: member,
          principalCents: cents,
          loanDate: date);
      await app.refresh();
      if (context.mounted) showNote(context, 'Loan recorded ✓');
    } catch (e) {
      if (context.mounted) showNote(context, 'Could not save: ${friendlyError(e)}', error: true);
    }
  }
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
            '${member.name} — ${isActive ? '${money(out ?? 0)} to pay' : money(loan.owedCents)}'),
        subtitle: Text(isActive
            ? 'Took ${money(loan.principalCents)} on ${prettyDate(fromIso(loan.loanDate))} · due Sat ${prettyDate(fromIso(loan.dueDate))}'
            : loan.status == 'paid'
                ? 'Paid off ${loan.closedOn != null ? 'on ${prettyDate(fromIso(loan.closedOn!))}' : ''}'
                : 'Rolled over into a new loan'),
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
    final newOwed = domain.owedFor(out, interestPercent: app.cycle!.interestPct);
    final sunday = domain.sundayAfter(fromIso(loan.dueDate));
    final newDue = domain.dueDateFor(sunday);
    return Card(
      color: kDanger.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${member.name} still owes ${money(out)}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
                'This was due Saturday ${satDate(fromIso(loan.dueDate))}. '
                'If it was paid on time, record the payment. Otherwise the '
                'rest becomes a new loan: ${money(newOwed)} to pay by '
                'Saturday ${satDate(newDue)}.',
                style: const TextStyle(fontSize: 15, height: 1.4)),
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
                          showNote(context, 'Could not roll over: ${friendlyError(e)}',
                              error: true);
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
  if (today().isAfter(due)) paidOn = due;

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
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${member.name} pays back',
                style: Theme.of(ctx).textTheme.titleLarge),
            Text('Still to pay: ${money(out)}',
                style: const TextStyle(color: Colors.black54, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount (US\$)',
                suffixIcon: TextButton(
                  onPressed: () => amountCtrl.text =
                      (out / 100).toStringAsFixed(2),
                  child: const Text('Pay all'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Paid on'),
              subtitle: Text(prettyDate(paidOn)),
              trailing: const Icon(Icons.edit_calendar),
              onTap: () async {
                final d = await showDatePicker(
                    context: ctx,
                    initialDate: paidOn,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now());
                if (d != null) {
                  setSheet(() =>
                      paidOn = domain.day(d.year, d.month, d.day));
                }
              },
            ),
            if (sheetError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(sheetError!,
                    style: const TextStyle(
                        color: kDanger,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final cents = parseUsdToCents(amountCtrl.text);
                if (cents == null || cents <= 0 || cents > out) {
                  setSheet(() => sheetError = cents == null || cents <= 0
                      ? 'Enter a valid amount'
                      : 'That is more than the ${money(out)} owed');
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
    message: '${member.name} paid ${money(cents)} on ${prettyDate(date)}.\n\n'
        '${cents == out ? 'This pays the loan off completely. 🎉' : 'They will still owe ${money(out - cents)} (due date stays the same).'}',
  );
  if (!ok || !context.mounted) return;
  try {
    await app.repo
        .recordPayment(loan: loan, amountCents: cents, paidOn: date);
    await app.refresh();
    if (context.mounted) showNote(context, 'Payment recorded ✓');
  } catch (e) {
    if (context.mounted) showNote(context, 'Could not save: ${friendlyError(e)}', error: true);
  }
}

class _TakeLoanSheet extends StatefulWidget {
  final List<Member> members;
  const _TakeLoanSheet({required this.members});

  @override
  State<_TakeLoanSheet> createState() => _TakeLoanSheetState();
}

class _TakeLoanSheetState extends State<_TakeLoanSheet> {
  Member? _member;
  final _amountCtrl = TextEditingController();
  DateTime _date = today();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New loan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<Member>(
            initialValue: _member,
            decoration: const InputDecoration(labelText: 'Who is borrowing?'),
            items: [
              for (final m in widget.members)
                DropdownMenuItem(value: m, child: Text(m.name))
            ],
            onChanged: (m) => setState(() => _member = m),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount (US\$)'),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Taken on'),
            subtitle: Text(prettyDate(_date)),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () async {
              final d = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2015),
                  lastDate: DateTime.now());
              if (d != null) {
                setState(() => _date = domain.day(d.year, d.month, d.day));
              }
            },
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!,
                  style: const TextStyle(
                      color: kDanger,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final cents = parseUsdToCents(_amountCtrl.text);
              if (_member == null) {
                setState(() => _error = 'Choose a member');
                return;
              }
              if (cents == null || cents <= 0) {
                setState(() => _error = 'Enter a valid amount');
                return;
              }
              Navigator.pop(context, (_member!, cents, _date));
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
