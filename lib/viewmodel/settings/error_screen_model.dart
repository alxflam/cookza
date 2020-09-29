import 'dart:convert';

import 'package:cookza/model/json/exception_log.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';

class ErrorScreenModel with ChangeNotifier {
  Future<List<ExceptionItem>> get errors async {
    String serializedLogModel = await _getSerializedLogModel();
    if (serializedLogModel.isEmpty) {
      /// directly return if the files content is empty
      return [];
    }
    var json = jsonDecode(serializedLogModel);
    var logModel = ExceptionLog.fromJson(json);
    return logModel.errors;
  }

  Future<String> get errorsAsText async {
    return await _getSerializedLogModel();
  }

  Future<String> _getSerializedLogModel() async {
    var file = await sl.get<StorageProvider>().getExeptionLogFile();
    if (!file.existsSync()) {
      return '';
    }
    return file.readAsStringSync();
  }

  void clearLog() {
    Future<void> result = sl.get<StorageProvider>().clearExceptionLogFile();
    result.then((value) => this.notifyListeners());
  }
}
