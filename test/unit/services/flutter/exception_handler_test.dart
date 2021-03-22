import 'dart:io';

import 'package:cookza/constants.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/file_mock.dart';
import '../../../mocks/shared_mocks.mocks.dart';

// class StackTraceMock extends Mock implements StackTrace {}

var sp = MockStorageProvider();

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<StorageProvider>(sp);
  });

  test('Add exception', () async {
    var file = FakeFile();
    file.stubContent('');
    when(sp.getExeptionLogFile()).thenAnswer((_) => Future.value(file));

    var cut = ExceptionHandlerImpl();
    var date = kDateFormatter.parse('01.01.2020');
    await cut.reportException('Some Error', StackTrace.current, date);

    verify(sp.updateExeptionLogFile(any));
  });
}
