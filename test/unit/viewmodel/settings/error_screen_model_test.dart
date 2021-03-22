import 'dart:io';

import 'package:cookza/services/local_storage.dart';
import 'package:cookza/viewmodel/settings/error_screen_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/file_mock.dart';
import '../../../mocks/shared_mocks.mocks.dart';

void main() {
  var mock = MockStorageProvider();

  setUpAll(() {
    GetIt.I.registerSingleton<StorageProvider>(mock);
  });

  test('Exception file exists', () async {
    var cut = ErrorScreenModel();
    var file = FakeFile();
    var json =
        '{"errors":[{"error":"Some Error","stackTrace":"StackTrace","date":"19.09.2020"}]}';

    file.stubExists(true);
    file.stubContent(json);
    when(mock.getExeptionLogFile())
        .thenAnswer((realInvocation) => Future.value(file));

    var errors = await cut.errors;
    var errorsAsText = await cut.errorsAsText;
    expect(errors.length, 1);
    expect(errorsAsText, json);
  });

  test('Clear log', () async {
    var cut = ErrorScreenModel();
    var file = FakeFile();

    file.stubExists(true);
    when(mock.getExeptionLogFile()).thenAnswer((_) => Future<File>.value(file));
    when(mock.clearExceptionLogFile()).thenAnswer((_) => Future.value());

    cut.clearLog();
    verify(mock.clearExceptionLogFile());
  });

  test('Exception file does not exist', () async {
    var cut = ErrorScreenModel();

    var errors = await cut.errors;
    var errorsAsText = await cut.errorsAsText;
    expect(errors.length, 0);
    expect(errorsAsText, '');
  });
}
