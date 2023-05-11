import 'dart:convert';
import 'dart:io';

import 'package:cookza/model/json/exception_log.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';

abstract class ExceptionHandler {
  Future<void> reportException(
      Object error, StackTrace? stackTrace, DateTime dateTime);
}

class ExceptionHandlerImpl implements ExceptionHandler {
  @override
  Future<void> reportException(
      Object error, StackTrace? stackTrace, DateTime dateTime) async {
    /// serialize stack trace
    var stackString = stackTrace?.toString();

    /// create a model
    var newError = ExceptionItem(
        stackTrace: stackString, date: dateTime, error: error.toString());

    /// read and parse the persisted log file
    var sp = sl.get<StorageProvider>();
    File logFile = await sp.getExeptionLogFile();
    var content = '';
    if (logFile.existsSync()) {
      content = logFile.readAsStringSync();
    }

    ExceptionLog logModel = getLogModel(content);

    /// then add the model to the persisted log
    logModel.errors.add(newError);
    var json = jsonEncode(logModel.toJson());
    return sp.updateExeptionLogFile(json);
  }

  ExceptionLog getLogModel(String content) {
    if (content.isEmpty) {
      return ExceptionLog(errors: []);
    }
    try {
      return ExceptionLog.fromJson(jsonDecode(content));
    } on FormatException {
      /// create a new empty exception log if some weird string got persisted that can't be deserialized
      /// this should only happen whilst development is ongoing...
      return ExceptionLog(errors: []);
    }
  }
}
