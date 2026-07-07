/// Money helpers. All amounts everywhere in QuickBucks are integer US cents.
/// SPEC.md: "Money is integer cents. Never floats."
library;

/// Multiplies [cents] by `percent/100` using round-half-up, staying in integers.
///
/// Used for the flat 20% loan interest: `owedFor(principal)` below.
int percentOfHalfUp(int cents, int percent) {
  if (cents < 0) {
    throw ArgumentError.value(cents, 'cents', 'must be >= 0');
  }
  if (percent < 0) {
    throw ArgumentError.value(percent, 'percent', 'must be >= 0');
  }
  // (cents * percent) / 100, rounded half-up — pure integer math.
  return (cents * percent + 50) ~/ 100;
}

/// Rounds [cents] to the nearest whole dollar, half up (SPEC §0: "coins
/// auto conversion to nearest dollar"). $27.60 → $28; $27.40 → $27;
/// $27.50 → $28. Negative amounts round symmetrically (-$27.60 → -$28).
int roundToDollarHalfUp(int cents) {
  final sign = cents < 0 ? -1 : 1;
  final abs = cents.abs();
  return sign * (((abs + 50) ~/ 100) * 100);
}

/// Whether [cents] is a whole-dollar amount (SPEC §0: entered amounts must
/// be whole dollars).
bool isWholeDollars(int cents) => cents % 100 == 0;

/// Total owed on a loan: principal + [interestPercent]%, rounded to the
/// nearest whole dollar (SPEC 3.1 + §0). Borrow $23 → 1.2 × $23 = $27.60
/// → owes $28. Set [wholeDollars] false only to reproduce pre-2026-07-07
/// history (cent rounding).
int owedFor(int principalCents,
    {int interestPercent = 20, bool wholeDollars = true}) {
  if (principalCents <= 0) {
    throw ArgumentError.value(principalCents, 'principalCents', 'must be > 0');
  }
  final owed =
      principalCents + percentOfHalfUp(principalCents, interestPercent);
  return wholeDollars ? roundToDollarHalfUp(owed) : owed;
}

/// Formats cents as US dollars: 123450 → `$1,234.50`. Whole-dollar amounts
/// drop the coins (SPEC §0): 2800 → `$28`. Negative → `-$12`.
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
  return rem == '00' ? '$sign\$$buf' : '$sign\$$buf.$rem';
}
