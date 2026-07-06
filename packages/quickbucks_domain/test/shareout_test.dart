import 'dart:math';

import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('largestRemainderSplit', () {
    test('splits exactly, no cent lost', () {
      final parts = largestRemainderSplit(10000, [1, 1, 1]); // $100 / 3
      expect(parts.reduce((a, b) => a + b), 10000);
      expect(parts..sort(), [3333, 3333, 3334]);
    });
    test('proportional to multipliers', () {
      final parts = largestRemainderSplit(15000, [1, 2, 3]);
      expect(parts, [2500, 5000, 7500]);
    });
    test('guards', () {
      expect(() => largestRemainderSplit(100, []), throwsArgumentError);
      expect(() => largestRemainderSplit(100, [1, 0]), throwsArgumentError);
      expect(() => largestRemainderSplit(-1, [1]), throwsArgumentError);
    });
  });

  group('computeShareOut (SPEC 5)', () {
    test('debts are settled against shares; Σpayout == cash', () {
      // cash 900_00, Mary still owes 84_00 -> pot 984_00.
      final r = computeShareOut(
        cashCents: 90000,
        multipliers: {'mary': 3, 'jane': 2, 'ruth': 1}, // total 6
        outstandingByMember: {'mary': 8400},
      );
      expect(r.potCents, 98400);
      expect(r.lines[0].shareCents, 49200); // 3/6
      expect(r.lines[0].payoutCents, 49200 - 8400);
      expect(r.lines[1].shareCents, 32800); // 2/6
      expect(r.lines[2].shareCents, 16400); // 1/6
      expect(r.lines.fold(0, (s, l) => s + l.payoutCents), 90000);
    });

    test('negative final balance when debt exceeds share (SPEC 5)', () {
      final r = computeShareOut(
        cashCents: 1000,
        multipliers: {'a': 1, 'b': 1},
        outstandingByMember: {'a': 5000}, // pot 6000, share 3000 each
      );
      final a = r.lines.firstWhere((l) => l.memberId == 'a');
      expect(a.payoutCents, -2000); // shown as negative on her balance sheet
      expect(r.lines.fold(0, (s, l) => s + l.payoutCents), 1000);
    });

    test('property: Σpayout == cash and Σshare == pot for random scenarios',
        () {
      final rng = Random(20260706); // deterministic
      for (var iter = 0; iter < 2000; iter++) {
        final n = 1 + rng.nextInt(15);
        final multipliers = <String, int>{
          for (var i = 0; i < n; i++) 'm$i': 1 + rng.nextInt(9)
        };
        final outstanding = <String, int>{
          for (var i = 0; i < n; i++)
            if (rng.nextBool()) 'm$i': rng.nextInt(200000)
        };
        final cash = rng.nextInt(5000000);
        final r = computeShareOut(
          cashCents: cash,
          multipliers: multipliers,
          outstandingByMember: outstanding,
        );
        expect(r.lines.fold(0, (s, l) => s + l.shareCents), r.potCents);
        expect(r.lines.fold(0, (s, l) => s + l.payoutCents), cash);
      }
    });
  });
}
