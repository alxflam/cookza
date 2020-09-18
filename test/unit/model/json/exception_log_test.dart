import 'package:cookly/constants.dart';
import 'package:cookly/model/json/exception_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse from JSON', () async {
    var now = kDateFormatter.format(DateTime.now());
    var nowDate = kDateFormatter.parse(now);

    var jsonItem = {
      'error': 'Some Error',
      'stackTrace': 'StackTrace',
      'date': now,
    };
    var item = ExceptionItem.fromJson(jsonItem);

    var json = {
      'errors': [
        item.toJson(),
      ]
    };
    var cut = ExceptionLog.fromJson(json);

    expect(cut.errors.length, 1);
    expect(cut.errors.first.error, 'Some Error');
    expect(cut.errors.first.stackTrace, 'StackTrace');
    expect(cut.errors.first.date, nowDate);
  });

  test('Item to Json', () async {
    var now = kDateFormatter.format(DateTime.now());

    var jsonItem = {
      'error': 'Some Error',
      'stackTrace': 'StackTrace',
      'date': now,
    };
    var item = ExceptionItem.fromJson(jsonItem);
    var actual = item.toJson();
    expect(actual, jsonItem);
  });

  test('ExceptionLog to Json', () async {
    var now = kDateFormatter.format(DateTime.now());

    var jsonItem = {
      'error': 'Some Error',
      'stackTrace': 'StackTrace',
      'date': now,
    };
    var item = ExceptionItem.fromJson(jsonItem);
    var json = {
      'errors': [
        item.toJson(),
      ]
    };
    var cut = ExceptionLog.fromJson(json);

    var actual = cut.toJson();
    expect(actual, json);
  });
}
