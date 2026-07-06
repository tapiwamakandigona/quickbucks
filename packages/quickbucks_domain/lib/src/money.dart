/// Money helpers. All amounts everywhere in QuickBucks are integer US cents.
/// SPEC.md: "Money is integer cents. Never floats."
library;

/// Multiplies [cents] by `percent/100` using round-half-up, staying in integers.
///
/// Used for the flat 20% loan interest: `owedFor(principal)` below.
int percentOfHalfUp(int cents, int percent) {
  if (cents < 0) throw ArgumentError.value(cents, 'cents', 'must be >= 0');
  if (percent < 0)
    throw ArgumentError.value(percent, 'percent', 'must be >= 0');
  // (cents * percent) / 100, rounded half-up — pure integer math.
  return (cents * percent + 50) ~/ 100;
}

/// Total owed on a loan: principal + [interestPercent]% (SPEC 3.1).
/// Default 20%: borrow P → owe round_half_up(1.2 × P).
int owedFor(int principalCents, {int interestPercent = 20}) {
  if (principalCents <= 0) {
    throw ArgumentError.value(principalCents, 'principalCents', 'must be > 0');
  }
  return principalCents + percentOfHalfUp(principalCents, interestPercent);
}

/// Formats cents as US dollars: 123450 → `$1,234.50`. Negative → `-$12.00`.
String formatUsd(int cents) {
  final sign = cents < 0 ? '-' : '';
  final abs = cents.abs();
  final dollars = abs ~/ 100;
  final rem = (abs % 100).toString().padLeft(2, '0');
  final digits = dollars.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return '$sign\$$buf.$rem';
}
