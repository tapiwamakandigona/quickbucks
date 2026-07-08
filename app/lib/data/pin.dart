/// App PIN lock (owner request 2026-07-06: "password setting for the app").
/// A 4–6 digit PIN, stored as salted SHA-256 in SharedPreferences.
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHash = 'pin_hash';
const _kSalt = 'pin_salt';
const _kLen = 'pin_length';

String _hash(String pin, String salt) =>
    sha256.convert(utf8.encode('$salt:$pin')).toString();

Future<bool> pinIsSet() async =>
    (await SharedPreferences.getInstance()).containsKey(_kHash);

/// Returns the stored PIN length (4–6). Defaults to 6 if not stored
/// (legacy PINs set before length tracking).
Future<int> pinLength() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_kLen) ?? 6;
}

Future<void> setPin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  final salt = base64Encode(
    List<int>.generate(16, (_) => Random.secure().nextInt(256)),
  );
  await prefs.setString(_kSalt, salt);
  await prefs.setString(_kHash, _hash(pin, salt));
  await prefs.setInt(_kLen, pin.length);
}

Future<void> clearPin() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kHash);
  await prefs.remove(_kSalt);
  await prefs.remove(_kLen);
}

Future<bool> checkPin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  final hash = prefs.getString(_kHash);
  final salt = prefs.getString(_kSalt);
  if (hash == null || salt == null) return true; // no PIN set
  return _hash(pin, salt) == hash;
}
