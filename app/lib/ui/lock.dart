import 'package:flutter/material.dart';

import '../data/pin.dart' as pin;
import 'common.dart';

/// Full-screen PIN gate shown on app start when a PIN is set.
class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _entered = '';
  bool _wrong = false;

  Future<void> _tap(String digit) async {
    if (_entered.length >= 6) return;
    setState(() {
      _entered += digit;
      _wrong = false;
    });
    if (_entered.length >= 4 && await pin.checkPin(_entered)) {
      widget.onUnlocked();
    } else if (_entered.length == 6) {
      setState(() {
        _wrong = true;
        _entered = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 56, color: scheme.primary),
            const SizedBox(height: 12),
            const Text('Enter your PIN',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            if (_wrong)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Wrong PIN — try again',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                    margin: const EdgeInsets.all(6),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _entered.length
                          ? scheme.primary
                          : Colors.black12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            for (final row in ['123', '456', '789', ' 0⌫'])
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final ch in row.split(''))
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: SizedBox(
                        width: 84,
                        height: 72,
                        child: ch == ' '
                            ? const SizedBox()
                            : OutlinedButton(
                                onPressed: () {
                                  if (ch == '⌫') {
                                    setState(() => _entered = _entered.isEmpty
                                        ? ''
                                        : _entered.substring(
                                            0, _entered.length - 1));
                                  } else {
                                    _tap(ch);
                                  }
                                },
                                child: Text(ch,
                                    style: const TextStyle(fontSize: 26)),
                              ),
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

/// Set / change / remove the PIN. Returns when done.
Future<void> managePin(BuildContext context) async {
  final hasPin = await pin.pinIsSet();
  if (!context.mounted) return;
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.password),
          title: Text(hasPin ? 'Change PIN' : 'Set a PIN'),
          onTap: () => Navigator.pop(ctx, 'set'),
        ),
        if (hasPin)
          ListTile(
            leading: const Icon(Icons.lock_open),
            title: const Text('Remove PIN'),
            onTap: () => Navigator.pop(ctx, 'remove'),
          ),
      ],
    ),
  );
  if (action == null || !context.mounted) return;
  if (action == 'remove') {
    await pin.clearPin();
    if (context.mounted) showNote(context, 'PIN removed');
    return;
  }
  final newPin = await _askPin(context, 'Choose a PIN (4–6 numbers)');
  if (newPin == null || !context.mounted) return;
  final again = await _askPin(context, 'Type the same PIN again');
  if (again == null || !context.mounted) return;
  if (newPin != again) {
    showNote(context, 'The PINs did not match — nothing changed', error: true);
    return;
  }
  await pin.setPin(newPin);
  if (context.mounted) {
    showNote(context,
        'PIN set ✓ — don\'t forget it! Without it the app cannot be opened.');
  }
}

Future<String?> _askPin(BuildContext context, String title) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: const TextStyle(fontSize: 24, letterSpacing: 8),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final v = ctrl.text.trim();
            if (v.length < 4 || int.tryParse(v) == null) return;
            Navigator.pop(ctx, v);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
