import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class StorageProvider {
  Future<bool> fileExists(String path);

  Future<String> getTempDirectory();
  Future<String> getImageDirectory();
}

class LocalStorageProvider implements StorageProvider {
  static final String imageSubdirectory = "images";

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
}
