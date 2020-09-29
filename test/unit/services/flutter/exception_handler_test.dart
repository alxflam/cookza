import 'dart:io';

import 'package:cookza/constants.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../viewmodel/settings/error_screen_model_test.dart';

class FileMock extends Mock implements File {}

class StackTraceMock extends Mock implements StackTrace {}

var sp = StorageProviderMock();

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<StorageProvider>(sp);
  });

  test('Add exception', () async {
    var file = FileMock();

    when(file.readAsStringSync()).thenReturn('');
    when(sp.getExeptionLogFile()).thenAnswer((_) => Future.value(file));

    var cut = ExceptionHandlerImpl();
    var date = kDateFormatter.parse('01.01.2020');
    await cut.reportException('Some Error', StackTrace.current, date);

    verify(sp.updateExeptionLogFile(any));
  });
}
