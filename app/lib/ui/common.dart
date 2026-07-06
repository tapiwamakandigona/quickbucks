import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickbucks_domain/quickbucks_domain.dart' as domain;

import '../theme.dart';

final _dateFmt = DateFormat('EEE, d MMM yyyy');
String prettyDate(DateTime d) => _dateFmt.format(d);

String money(int cents) => domain.formatUsd(cents);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color ?? Colors.black87)),
      ],
    );
  }
}
