import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'First of January is 53th week of previous year',
    () async {
      int week = weekNumberOf(DateTime(2016, 1, 1));

      expect(week, 53);
    },
  );

  test(
    'First of January is 52nd week of previous year',
    () async {
      int week = weekNumberOf(DateTime(2006, 1, 1));

      expect(week, 52);
    },
  );

  test(
    'First of January is first week',
    () async {
      int week = weekNumberOf(DateTime(2015, 1, 1));

      expect(week, 1);
    },
  );

  test(
    'Date in May',
    () async {
      int week = weekNumberOf(DateTime(2020, 5, 17));

      expect(week, 20);
    },
  );

  test(
    'Last day of december is 53th week',
    () async {
      int week = weekNumberOf(DateTime(2015, 12, 31));

      expect(week, 53);
    },
  );

  test(
    'Last day of december is 52nd week',
    () async {
      int week = weekNumberOf(DateTime(2005, 12, 31));

      expect(week, 52);
    },
  );

  test(
    'Last day of december is first week of next year',
    () async {
      int week = weekNumberOf(DateTime(2014, 12, 31));

      expect(week, 1);
    },
  );
}