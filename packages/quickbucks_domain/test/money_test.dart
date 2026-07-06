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
    test('round half-up on odd cents: 1c -> 1c (0.2c rounds down: <0.5)', () {
      expect(owedFor(1), 1); // 1 + round(0.2) = 1 + 0
    });
    test('round half-up: 3c -> 4c (0.6c rounds up)', () {
      expect(owedFor(3), 4); // 3 + round(0.6) = 3 + 1
    });
    test('exact half rounds up: \$0.025 interest -> 13c + 3c', () {
      // 13c * 20% = 2.6c -> 3c
      expect(owedFor(13), 16);
      // 5c * 20% = 1c exactly
      expect(owedFor(5), 6);
      // 12c * 20% = 2.4c -> 2c
      expect(owedFor(12), 14);
    });
    test('rejects zero/negative principal', () {
      expect(() => owedFor(0), throwsArgumentError);
      expect(() => owedFor(-100), throwsArgumentError);
    });
  });

  group('formatUsd', () {
    test('grouping and cents', () {
      expect(formatUsd(123450), r'$1,234.50');
      expect(formatUsd(100), r'$1.00');
      expect(formatUsd(5), r'$0.05');
      expect(formatUsd(1234567890), r'$12,345,678.90');
    });
    test('negative balances (share-out can go negative, SPEC 5)', () {
      expect(formatUsd(-8400), r'-$84.00');
    });
    test('zero', () {
      expect(formatUsd(0), r'$0.00');
    });
  });
}
