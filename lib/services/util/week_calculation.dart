import 'package:flutter/material.dart';
import 'package:week_of_year/week_of_year.dart';

/// calculate the week of the given date according to ISO 8601
/// the first week of a year is the week which contains the first thursday of the year
/// each week starts on monday (index 1) and ends sundays (index 7)
int weekNumberOf(DateTime date) {
  // create a new instance to eliminate side effects by comparing DateTime instances with time fractions
  var dateWithoutTime = DateTime.utc(date.year, date.month, date.day);
  return dateWithoutTime.weekOfYear;
}

/// Delegates to [DateUtils] but returns false if both dates given are null
bool isSameDay(DateTime? first, DateTime? second) {
  if (first == null || second == null) {
    return false;
  }
  return DateUtils.isSameDay(first, second);
}
