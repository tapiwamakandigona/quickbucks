import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('owedFor: flat 20% (SPEC 3.1)', () {
    test('borrow \$100 -> owe \$120', () {
      expect(owedFor(10000), 12000);
    });
    test('borrow \$70 -> owe \$84 (Mary rollover amount)', () {
      expect(owedFor(7000), 8400);
    });
    test('coins round to the nearest dollar (SPEC §0): \$23 -> \$28', () {
      // 1.2 × $23 = $27.60 → $28 (owner example, 2026-07-07)
      expect(owedFor(2300), 2800);
    });
    test('nearest-dollar rounds down below 50c: \$31 -> \$37', () {
      // 1.2 × $31 = $37.20 → $37
      expect(owedFor(3100), 3700);
    });
    test('exactly 50c rounds up: \$27.50-ish totals', () {
      // 1.2 × $22.92 = $27.504 → cents 2750 → $28
      expect(roundToDollarHalfUp(2750), 2800);
      expect(roundToDollarHalfUp(2749), 2700);
      expect(roundToDollarHalfUp(-2750), -2800);
    });
    test('legacy cent rounding still reproducible (wholeDollars: false)', () {
      expect(owedFor(1, wholeDollars: false), 1); // 1 + round(0.2) = 1
      expect(owedFor(3, wholeDollars: false), 4); // 3 + round(0.6) = 4
      expect(owedFor(13, wholeDollars: false), 16); // 2.6c -> 3c
      expect(owedFor(2300, wholeDollars: false), 2760);
    });
    test('rejects zero/negative principal', () {
      expect(() => owedFor(0), throwsArgumentError);
      expect(() => owedFor(-100), throwsArgumentError);
    });
  });

  group('isWholeDollars (SPEC §0 entry rule)', () {
    test('whole dollars pass, coins fail', () {
      expect(isWholeDollars(2800), isTrue);
      expect(isWholeDollars(0), isTrue);
      expect(isWholeDollars(2760), isFalse);
      expect(isWholeDollars(1), isFalse);
    });
  });

  group('formatUsd', () {
    test('whole dollars drop the coins (SPEC §0)', () {
      expect(formatUsd(2800), r'$28');
      expect(formatUsd(100), r'$1');
      expect(formatUsd(1234500), r'$12,345');
    });
    test('legacy coin amounts keep their cents', () {
      expect(formatUsd(123450), r'$1,234.50');
      expect(formatUsd(5), r'$0.05');
      expect(formatUsd(1234567890), r'$12,345,678.90');
    });
    test('negative balances (share-out can go negative, SPEC 5)', () {
      expect(formatUsd(-8400), r'-$84');
      expect(formatUsd(-8450), r'-$84.50');
    });
    test('zero', () {
      expect(formatUsd(0), r'$0');
    });
  });
}
