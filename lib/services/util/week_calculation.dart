/// calculate the week of the given date according to ISO 8601
/// the first week of a year is the week which contains the first thursday of the year
/// each week starts on monday (index 1) and ends sundays (index 7)
int weekNumberOf(DateTime date) {
  // create a new instance to eliminate side effects by comparing DateTime instances with time fractions
  var dateWithoutTime = DateTime(date.year, date.month, date.day);
  // calculate the offset in days to the thursday in the same week as the given date
  var offset = DateTime.thursday - dateWithoutTime.weekday;
  // then calculate the thursday of the week
  var thursday = offset > 0
      ? dateWithoutTime.add(Duration(days: offset))
      : dateWithoutTime.subtract(Duration(days: offset.abs()));
  // next calculate the difference from the thursday to the first day of the given year
  var elapsedDays = thursday.difference(DateTime(thursday.year, 1, 1)).inDays;
  // the week number is the difference of days between the given thursday and the first day of the year divided by 7
  // if the given date is actually the first thirsday and the first day of the year,
  // the elapsedDays are zero, hence one day needs to be added
  if (elapsedDays == 6) {
    elapsedDays--;
  }

  return 1 + ((elapsedDays + 1) / 7).floor();
}

bool isSameDay(DateTime? first, DateTime? second) {
  if (first == null || second == null) {
    return false;
  }
  return first.day == second.day &&
      first.month == second.month &&
      first.year == second.year;
}
