import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class StorageProvider {
  Future<bool> fileExists(String path);

  Future<String> getTempDirectory();
  Future<String> getImageDirectory();
  Future<File> getExeptionLogFile();
  Future<void> updateExeptionLogFile(String content);
  Future<void> clearExceptionLogFile();
}

class LocalStorageProvider implements StorageProvider {
  static final String imageSubdirectory = "images";
  static final String exceptionLogFileName = "exceptions.log";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<bool> fileExists(String path) async {
    final file = File(path);
    return file.exists();
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
    String path = await _localPath;
    var logFilePath = '$path/$exceptionLogFileName';
    var logFile = File(logFilePath);
    if (!logFile.existsSync()) {
      logFile.createSync();
    }
    return logFile;
  }

  @override
  Future<void> updateExeptionLogFile(String content) async {
    String path = await _localPath;
    var logFilePath = '$path/$exceptionLogFileName';
    var logFile = File(logFilePath);
    return logFile.writeAsString(content);
  }

  Future<void> clearExceptionLogFile() {
    return updateExeptionLogFile('');
  }
}
