import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../theme.dart';

final _dateFmt = DateFormat('EEE, d MMM yyyy');
String prettyDate(DateTime d) => _dateFmt.format(d);

final _shortFmt = DateFormat('d MMM');

/// Compact date for dense tables, e.g. '7 Feb'.
String shortDate(DateTime d) => _shortFmt.format(d);

/// For use right after the word "Saturday": no repeated weekday.
final _satFmt = DateFormat('d MMMM yyyy');
String satDate(DateTime d) => _satFmt.format(d);

String money(int cents) => domain.formatUsd(cents);

/// Turns exceptions into calm, plain-English text (no "Bad state:" jargon).
String friendlyError(Object e) {
  var msg = e.toString();
  for (final prefix in [
    'Bad state: ',
    'Invalid argument(s): ',
    'FormatException: ',
    'Exception: ',
    'ArgumentError: ',
  ]) {
    if (msg.startsWith(prefix)) msg = msg.substring(prefix.length);
  }
  // Very long / technical messages help nobody at the market.
  if (msg.length > 160 || msg.contains('SqliteException')) {
    return 'Something went wrong. Nothing was saved — please try again.';
  }
  return msg;
}

/// Parses whole-dollar input (SPEC §0): "12", "$12", "1,200", "12.00" → cents.
/// Coins are rejected ("12.50" → null) — the group works in whole dollars.
int? parseUsdToCents(String input) {
  final cleaned = input.replaceAll(r'$', '').replaceAll(',', '').trim();
  if (cleaned.isEmpty) return null;
  final match = RegExp(r'^(\d+)(?:\.(0{1,2}))?$').firstMatch(cleaned);
  if (match == null) return null;
  return int.parse(match.group(1)!) * 100;
}

/// Big tap-friendly chips for picking a Saturday — no calendar needed for
/// the usual case (owner 2026-07-07: make dates easy for his mother).
/// Shows the most recent cycle Saturdays newest-first, plus "Another day"
/// which opens a calendar that only allows Saturdays.
class SaturdayChips extends StatelessWidget {
  final List<DateTime> saturdays; // cycle Saturdays, oldest → newest
  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;
  final int visibleCount;
  const SaturdayChips({
    super.key,
    required this.saturdays,
    required this.selected,
    required this.onChanged,
    this.visibleCount = 4,
  });

  String _label(DateTime s) {
    final sats = saturdays;
    if (sats.isNotEmpty && s == sats.last) {
      return 'This Saturday · ${shortDate(s)}';
    }
    if (sats.length > 1 && s == sats[sats.length - 2]) {
      return 'Last Saturday · ${shortDate(s)}';
    }
    return prettyDate(s);
  }

  @override
  Widget build(BuildContext context) {
    final recent = saturdays.reversed.take(visibleCount).toList();
    final selectedIsOlder = selected != null && !recent.contains(selected);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in recent)
          ChoiceChip(
            label: Text(_label(s), style: const TextStyle(fontSize: 16)),
            selected: selected == s,
            onSelected: (_) => onChanged(s),
          ),
        if (selectedIsOlder)
          ChoiceChip(
            label: Text(
              prettyDate(selected!),
              style: const TextStyle(fontSize: 16),
            ),
            selected: true,
            onSelected: (_) {},
          ),
        ActionChip(
          avatar: const Icon(Icons.edit_calendar, size: 20),
          label: const Text('Another day', style: TextStyle(fontSize: 16)),
          onPressed: () async {
            final first = saturdays.isEmpty ? DateTime(2015) : saturdays.first;
            final d = await showDatePicker(
              context: context,
              initialDate:
                  selected ?? (saturdays.isEmpty ? null : saturdays.last),
              firstDate: first,
              lastDate: saturdays.isEmpty ? DateTime.now() : saturdays.last,
              selectableDayPredicate: (d) => d.weekday == DateTime.saturday,
              helpText: 'Pick a Saturday',
            );
            if (d != null) onChanged(domain.day(d.year, d.month, d.day));
          },
        ),
      ],
    );
  }
}

/// Confirmation dialog that restates the numbers (SPEC: every money action
/// gets a confirmation).
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String yes = 'Yes, record it',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message, style: const TextStyle(fontSize: 17, height: 1.4)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(fontSize: 17)),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(yes),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Success snackbar with an Undo button (fat-finger insurance).
///
/// Notes REPLACE each other instead of queueing — ticking ten members fast
/// used to stack ten 6-second notes (owner feedback 2026-07-06: "stays on
/// a bit too long, kinda gets annoying").
void showUndoNote(
  BuildContext context,
  String msg,
  Future<void> Function() onUndo,
) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              await onUndo();
              if (context.mounted) showNote(context, 'Undone — nothing saved');
            } catch (e) {
              if (context.mounted) {
                showNote(
                  context,
                  'Could not undo: ${friendlyError(e)}',
                  error: true,
                );
              }
            }
          },
        ),
      ),
    );
}

/// Quick note. Errors stay 4 s (needs reading); success flashes 2 s.
void showNote(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: error ? 4 : 2),
        backgroundColor: error ? kDanger : null,
      ),
    );
}

class BigStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const BigStat({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: QType.overline.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: QSpace.x1),
        Text(
          value,
          style: QType.money.copyWith(color: color ?? scheme.onSurface),
        ),
      ],
    );
  }
}
