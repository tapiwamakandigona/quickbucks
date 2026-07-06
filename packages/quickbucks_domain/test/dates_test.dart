import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('dueDateFor (SPEC 3.2 examples, verified 2026 calendar)', () {
    test('Wed 2026-07-01 -> day30 Fri 07-31 -> due Sat 2026-08-01', () {
      expect(dueDateFor(day(2026, 7, 1)), day(2026, 8, 1));
    });
    test('Sat 2026-07-04 -> day30 Mon 08-03 -> due Sat 2026-08-08', () {
      expect(dueDateFor(day(2026, 7, 4)), day(2026, 8, 8));
    });
    test('Thu 2026-07-09 -> day30 IS Sat 2026-08-08 -> due that same day', () {
      expect(dueDateFor(day(2026, 7, 9)), day(2026, 8, 8));
    });
    test('Sun 2026-08-02 -> day30 Tue 09-01 -> due Sat 2026-09-05', () {
      expect(dueDateFor(day(2026, 8, 2)), day(2026, 9, 5));
    });
    test('due date is always a Saturday, >= day30, < day30+7', () {
      for (var offset = 0; offset < 400; offset++) {
        final loanDate = addDays(day(2026, 1, 1), offset);
        final due = dueDateFor(loanDate);
        final day30 = addDays(loanDate, 30);
        expect(isSaturday(due), isTrue);
        expect(due.isBefore(day30), isFalse);
        expect(due.difference(day30).inDays, lessThan(7));
      }
    });
  });

  group('rollover eligibility (SPEC 3.4: Sunday-after rule)', () {
    final due = day(2026, 8, 1); // a Saturday
    test('on the due Saturday itself: NOT eligible (on-time day)', () {
      expect(isRolloverEligible(due, day(2026, 8, 1)), isFalse);
    });
    test('the Sunday after: eligible', () {
      expect(isRolloverEligible(due, day(2026, 8, 2)), isTrue);
    });
    test('any later day: eligible', () {
      expect(isRolloverEligible(due, day(2026, 9, 15)), isTrue);
    });
    test('before the due date: not eligible', () {
      expect(isRolloverEligible(due, day(2026, 7, 31)), isFalse);
    });
    test('sundayAfter rejects non-Saturdays', () {
      expect(() => sundayAfter(day(2026, 8, 2)), throwsArgumentError);
    });
  });

  group('saturdaysBetween (contribution grid, SPEC 2 & 7)', () {
    test('the real cycle: Sat 2026-02-01 start... is actually a Sunday', () {
      // 2026-02-01 is a Sunday; first contribution Saturday is 2026-02-07.
      expect(isSunday(day(2026, 2, 1)), isTrue);
    });
    test('Feb 1 to Jul 26 2026 range', () {
      final sats = saturdaysBetween(day(2026, 2, 1), day(2026, 7, 26));
      expect(sats.first, day(2026, 2, 7));
      expect(sats.last, day(2026, 7, 25));
      expect(sats.length, 25);
      expect(sats.every(isSaturday), isTrue);
    });
    test('start on a Saturday includes it', () {
      final sats = saturdaysBetween(day(2026, 7, 4), day(2026, 7, 4));
      expect(sats, [day(2026, 7, 4)]);
    });
    test('empty range', () {
      expect(saturdaysBetween(day(2026, 7, 5), day(2026, 7, 10)), isEmpty);
    });
  });
}
