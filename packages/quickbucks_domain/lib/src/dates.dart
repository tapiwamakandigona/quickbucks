/// Calendar-date helpers. QuickBucks business logic uses *local calendar
/// dates only* — no times, no timezones (SPEC.md ground rules).
///
/// Dates are represented as UTC-midnight [DateTime]s so day arithmetic can
/// never be corrupted by DST or timezone offsets. Use [day] to construct.
library;

/// Canonical date constructor: a timezone-proof calendar date.
DateTime day(int year, int month, int dayOfMonth) =>
    DateTime.utc(year, month, dayOfMonth);

/// Normalizes any [DateTime] to its calendar date (UTC midnight, using the
/// date's own year/month/day fields).
DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

bool isSaturday(DateTime d) => d.weekday == DateTime.saturday;
bool isSunday(DateTime d) => d.weekday == DateTime.sunday;

DateTime addDays(DateTime d, int days) => dateOnly(d).add(Duration(days: days));

/// The Saturday of the week of/after [d]: returns [d] itself if it is a
/// Saturday, else the next Saturday strictly after it.
DateTime saturdayOnOrAfter(DateTime d) {
  final base = dateOnly(d);
  final delta = (DateTime.saturday - base.weekday + 7) % 7;
  return addDays(base, delta);
}

/// Loan due-date rule (SPEC 3.2):
/// day30 = loan_date + 30 days; due = day30 if it is a Saturday, else the
/// next Saturday after it.
DateTime dueDateFor(DateTime loanDate) =>
    saturdayOnOrAfter(addDays(loanDate, 30));

/// The Sunday immediately after the given due Saturday — the moment a loan
/// becomes rollover-eligible (SPEC 3.4: paying ON the due Saturday is on
/// time; "the loan thing" starts the Sunday afterwards).
DateTime sundayAfter(DateTime dueSaturday) {
  if (!isSaturday(dueSaturday)) {
    throw ArgumentError.value(dueSaturday, 'dueSaturday', 'must be a Saturday');
  }
  return addDays(dueSaturday, 1);
}

/// Whether [today] is past the due Saturday, i.e. the loan may now roll over.
/// True from the Sunday after [dueSaturday] onwards.
bool isRolloverEligible(DateTime dueSaturday, DateTime today) =>
    !dateOnly(today).isBefore(sundayAfter(dueSaturday));

/// All Saturdays from [start] to [end] inclusive (contribution grid,
/// SPEC 2). Returns an empty list if the range contains no Saturday.
List<DateTime> saturdaysBetween(DateTime start, DateTime end) {
  final result = <DateTime>[];
  var s = saturdayOnOrAfter(start);
  final last = dateOnly(end);
  while (!s.isAfter(last)) {
    result.add(s);
    s = addDays(s, 7);
  }
  return result;
}
