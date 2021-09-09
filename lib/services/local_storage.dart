import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class StorageProvider {
  Future<String> getTempDirectory();
  Future<String> getImageDirectory();
  Future<File> getExeptionLogFile();
  Future<void> updateExeptionLogFile(String content);
  Future<void> clearExceptionLogFile();
}

class LocalStorageProvider implements StorageProvider {
  static const String imageSubdirectory = 'images';
  static const String exceptionLogFileName = 'exceptions.log';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<String> getImageDirectory() async {
    String path = await _localPath;
    var imageDirectoryPath = '$path/$imageSubdirectory';
    var directory = Directory(imageDirectoryPath);
    if (!directory.existsSync()) {
      directory.createSync();
    }
    return imageDirectoryPath;
  }

  @override
  Future<String> getTempDirectory() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  @override
  Future<File> getExeptionLogFile() async {
    String logFilePath = await _logFilePath();
    var logFile = File(logFilePath);
    if (!logFile.existsSync()) {
      logFile.createSync();
    }
    return logFile;
  }

  @override
  Future<File> updateExeptionLogFile(String content) async {
    String logFilePath = await _logFilePath();
    var logFile = File(logFilePath);
    return logFile.writeAsString(content);
  }

  Future<String> _logFilePath() async {
    String path = await _localPath;
    var logFilePath = '$path/$exceptionLogFileName';
    return logFilePath;
  }

  @override
  Future<void> clearExceptionLogFile() {
    return updateExeptionLogFile('');
  }
}
