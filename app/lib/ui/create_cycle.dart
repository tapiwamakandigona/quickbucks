import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../data/repo.dart';
import '../state.dart';
import 'common.dart';

class CreateCycleScreen extends StatefulWidget {
  const CreateCycleScreen({super.key});

  @override
  State<CreateCycleScreen> createState() => _CreateCycleScreenState();
}

class _MemberRow {
  final nameCtrl = TextEditingController();
  int multiplier = 1;
}

class _CreateCycleScreenState extends State<CreateCycleScreen> {
  final _nameCtrl = TextEditingController(text: 'Round ${DateTime.now().year}');
  DateTime _startDate = today();
  DateTime? _endDate;
  final List<_MemberRow> _rows = [_MemberRow()];
  bool _saving = false;

  Future<DateTime?> _pickDate(DateTime initial) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2015),
    lastDate: DateTime(2040),
  ).then((d) => d == null ? null : domain.day(d.year, d.month, d.day));

  Future<void> _save() async {
    final members = <MemberInput>[];
    for (final r in _rows) {
      final name = r.nameCtrl.text.trim();
      if (name.isEmpty) continue;
      members.add(MemberInput(name, r.multiplier));
    }
    if (members.isEmpty) {
      showNote(context, 'Add at least one member', error: true);
      return;
    }
    // M1: warn on duplicate names.
    final names = members.map((m) => m.name.toLowerCase()).toList();
    final dupes = <String>{};
    final seen = <String>{};
    for (final n in names) {
      if (!seen.add(n)) dupes.add(n);
    }
    if (dupes.isNotEmpty) {
      final ok = await confirmAction(
        context,
        title: 'Same name used twice',
        message:
            'You have more than one member called '
            '"${dupes.map((d) => members.firstWhere((m) => m.name.toLowerCase() == d).name).join(', ')}". '
            'Consider adding a last initial to tell them apart.\n\n'
            'Continue anyway?',
        yes: 'Continue',
      );
      if (!ok || !mounted) return;
    }
    final totalWeekly = members.fold(0, (s, m) => s + m.multiplier) * 1000;
    final ok = await confirmAction(
      context,
      title: 'Start this cycle?',
      message:
          '${members.length} members, starting ${prettyDate(_startDate)}.\n\n'
          'Together they pay ${money(totalWeekly)} every Saturday.\n\n'
          'Names and multipliers are locked once the cycle starts '
          '(dates can still be changed later).',
      yes: 'Start cycle',
    );
    if (!ok || !mounted) return;
    setState(() => _saving = true);
    try {
      await context.read<AppState>().repo.createCycle(
        name: _nameCtrl.text.trim().isEmpty
            ? 'Savings round'
            : _nameCtrl.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        members: members,
      );
      if (mounted) await context.read<AppState>().refresh();
    } catch (e) {
      if (mounted) {
        showNote(context, 'Could not start: ${friendlyError(e)}', error: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a savings cycle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome to QuickBucks! 🎉\nSet up the group below. You can enter '
            'a start date in the past and add old records afterwards.',
            style: TextStyle(fontSize: 17, height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Cycle name'),
          ),
          const SizedBox(height: 12),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Colors.black26),
            ),
            title: const Text('Start date'),
            subtitle: Text(prettyDate(_startDate)),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () async {
              final d = await _pickDate(_startDate);
              if (d != null) setState(() => _startDate = d);
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Colors.black26),
            ),
            title: const Text('End date (optional)'),
            subtitle: Text(
              _endDate == null
                  ? 'Not set — you can set or change it any time'
                  : prettyDate(_endDate!),
            ),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () async {
              final d = await _pickDate(_endDate ?? _startDate);
              if (d != null) setState(() => _endDate = d);
            },
          ),
          const SizedBox(height: 24),
          Text('Members', style: Theme.of(context).textTheme.titleLarge),
          const Text(
            'Each multiplier means \$10 every Saturday.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _rows.length; i++) _memberRow(i),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => setState(() => _rows.add(_MemberRow())),
            icon: const Icon(Icons.person_add),
            label: const Text('Add member'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const CircularProgressIndicator()
                : const Text('Start cycle'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _memberRow(int i) {
    final row = _rows[i];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: row.nameCtrl,
              decoration: InputDecoration(labelText: 'Member ${i + 1} name'),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: row.multiplier,
            items: [
              for (var m = 1; m <= 20; m++)
                DropdownMenuItem(value: m, child: Text('×$m')),
            ],
            onChanged: (v) => setState(() => row.multiplier = v ?? 1),
          ),
          IconButton(
            onPressed: _rows.length == 1
                ? null
                : () => setState(() => _rows.removeAt(i)),
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }
}
