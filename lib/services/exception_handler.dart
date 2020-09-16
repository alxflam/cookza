import 'dart:convert';
import 'dart:io';

import 'package:cookly/model/json/exception_log.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';

abstract class ExceptionHandler {
  Future<void> reportException(
      Object error, StackTrace stackTrace, DateTime dateTime);
}

class ExceptionHandlerImpl implements ExceptionHandler {
  @override
  Future<void> reportException(
      Object error, StackTrace stackTrace, DateTime dateTime) async {
    /// serialize stack trace
    var stackString = stackTrace.toString();

    /// create a model
    var newError = ExceptionItem(
        stackTrace: stackString, date: dateTime, error: error.toString());

    /// read and parse the persisted log file
    var sp = sl.get<StorageProvider>();
    File logFile = await sp.getExeptionLogFile();
    var content = logFile.readAsStringSync();
    if (content.isEmpty) {
      content = '''{ 

      }''';
    }

    ExceptionLog logModel;
    try {
      logModel = ExceptionLog.fromJson(jsonDecode(content));
    } on FormatException {
      /// create a new empty exception log if some weird string got persisted that can't be deserialized
      /// this should only happen whilst development is ongoing...
      logModel = new ExceptionLog();
    }

    /// then add the model to the persisted log
    logModel.errors.add(newError);
    var json = jsonEncode(logModel.toJson());
    return sp.updateExeptionLogFile(json);
  }
}
