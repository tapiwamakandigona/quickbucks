import 'package:quickbucks_domain/quickbucks_domain.dart';
import 'package:test/test.dart';

void main() {
  group('dueDateFor (SPEC 3.2 examples, verified 2026 calendar)', () {
    test("owner's example: Sat 2026-02-07 -> due Sat 2026-03-07 (a Saturday)",
        () {
      expect(dueDateFor(day(2026, 2, 7)), day(2026, 3, 7));
    });
    test('Wed 2026-07-01 -> Sat 08-01 IS a Saturday -> due that same day', () {
      expect(dueDateFor(day(2026, 7, 1)), day(2026, 8, 1));
    });
    test('Sat 2026-07-04 -> Tue 08-04 -> due Sat 2026-08-08', () {
      expect(dueDateFor(day(2026, 7, 4)), day(2026, 8, 8));
    });
    test('Thu 2026-07-09 -> Sun 08-09 -> due Sat 2026-08-15', () {
      expect(dueDateFor(day(2026, 7, 9)), day(2026, 8, 15));
    });
    test('Sun 2026-08-02 -> Wed 09-02 -> due Sat 2026-09-05', () {
      expect(dueDateFor(day(2026, 8, 2)), day(2026, 9, 5));
    });
    test('clamping: Sat 2026-01-31 -> Sat 02-28 (Feb has no 31st)', () {
      expect(sameDateNextMonth(day(2026, 1, 31)), day(2026, 2, 28));
      expect(dueDateFor(day(2026, 1, 31)), day(2026, 2, 28));
    });
    test('leap year clamping: 2028-01-31 -> 2028-02-29', () {
      expect(sameDateNextMonth(day(2028, 1, 31)), day(2028, 2, 29));
    });
    test('December wraps to January of the next year', () {
      expect(sameDateNextMonth(day(2026, 12, 15)), day(2027, 1, 15));
    });
    test('due date is always a Saturday within a week after the month day',
        () {
      for (var offset = 0; offset < 800; offset++) {
        final loanDate = addDays(day(2026, 1, 1), offset);
        final monthDay = sameDateNextMonth(loanDate);
        final due = dueDateFor(loanDate);
        expect(isSaturday(due), isTrue);
        expect(due.isBefore(monthDay), isFalse);
        expect(due.difference(monthDay).inDays, lessThan(7));
        // never earlier than 28 days out, never later than ~38
        final len = due.difference(loanDate).inDays;
        expect(len, greaterThanOrEqualTo(28));
        expect(len, lessThanOrEqualTo(38));
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
