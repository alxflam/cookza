import 'dart:io';

import 'package:cookza/services/local_storage.dart';
import 'package:cookza/viewmodel/settings/error_screen_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class StorageProviderMock extends Mock implements StorageProvider {}

class FileMock extends Mock implements File {}

void main() {
  var mock = StorageProviderMock();

  setUpAll(() {
    GetIt.I.registerSingleton<StorageProvider>(mock);
  });

  test('Exception file exists', () async {
    var cut = ErrorScreenModel();
    var file = FileMock();
    when(mock.getExeptionLogFile())
        .thenAnswer((realInvocation) => Future.value(file));
    when(file.existsSync()).thenReturn(true);
    var json =
        '{"errors":[{"error":"Some Error","stackTrace":"StackTrace","date":"19.09.2020"}]}';

    when(file.readAsStringSync()).thenReturn(json);

    var errors = await cut.errors;
    var errorsAsText = await cut.errorsAsText;
    expect(errors.length, 1);
    expect(errorsAsText, json);
  });

  test('Clear log', () async {
    var cut = ErrorScreenModel();
    var file = FileMock();
    when(mock.getExeptionLogFile())
        .thenAnswer((realInvocation) => Future.value(file));
    when(file.existsSync()).thenReturn(true);
    when(mock.clearExceptionLogFile())
        .thenAnswer((realInvocation) => Future.value());

    cut.clearLog();
    verify(mock.clearExceptionLogFile());
  });

  test('Exception file does not exist', () async {
    var cut = ErrorScreenModel();
    var file = FileMock();
    when(mock.getExeptionLogFile())
        .thenAnswer((realInvocation) => Future.value(file));
    when(file.existsSync()).thenReturn(false);

    var errors = await cut.errors;
    var errorsAsText = await cut.errorsAsText;
    expect(errors.length, 0);
    expect(errorsAsText, '');
  });
}
