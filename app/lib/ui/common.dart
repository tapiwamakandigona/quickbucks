import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../theme.dart';

final _dateFmt = DateFormat('EEE, d MMM yyyy');
String prettyDate(DateTime d) => _dateFmt.format(d);

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

/// Parses "12", "12.5", "12.50", "$12.50" → cents. Returns null if invalid.
int? parseUsdToCents(String input) {
  final cleaned = input.replaceAll(r'$', '').replaceAll(',', '').trim();
  if (cleaned.isEmpty) return null;
  final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
  if (match == null) return null;
  final dollars = int.parse(match.group(1)!);
  final centsPart = (match.group(2) ?? '0').padRight(2, '0');
  return dollars * 100 + int.parse(centsPart);
}

/// Confirmation dialog that restates the numbers (SPEC: every money action
/// gets a confirmation).
Future<bool> confirmAction(BuildContext context,
    {required String title, required String message, String yes = 'Yes, record it'}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message, style: const TextStyle(fontSize: 17, height: 1.4)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(fontSize: 17))),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(yes)),
      ],
    ),
  );
  return ok ?? false;
}

/// Success snackbar with a 6-second Undo button (fat-finger insurance).
void showUndoNote(
    BuildContext context, String msg, Future<void> Function() onUndo) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 6),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () async {
        try {
          await onUndo();
          if (context.mounted) showNote(context, 'Undone — nothing saved');
        } catch (e) {
          if (context.mounted) {
            showNote(context, 'Could not undo: ${friendlyError(e)}',
                error: true);
          }
        }
      },
    ),
  ));
}

void showNote(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: error ? kDanger : null,
  ));
}

class BigStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const BigStat({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: QType.overline.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: QSpace.x1),
        Text(value,
            style: QType.money.copyWith(color: color ?? scheme.onSurface)),
      ],
    );
  }
}
