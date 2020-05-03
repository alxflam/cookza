import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

abstract class StorageProvider {
  Future<bool> fileExists(String path);

  Future<bool> profileFileExists();
  Future<File> saveProfileFile(dynamic json);
  Future<File> getProfileFile();

  Future<bool> imageMappingFileExists();
  Future<File> saveImageMappingFile(dynamic json);
  Future<File> getImageMappingFile();
  Future<String> getImageDirectory();
  Future<String> getTempDirectory();
}

class LocalStorageProvider implements StorageProvider {
  static final String profileFileName = "profile.json";
  static final String imageMappingFileName = "images.json";
  static final String imageSubdirectory = "images";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile(String name) async {
    final path = await _localPath;
    return File('$path/$name');
  }

  @override
  Future<File> saveProfileFile(dynamic json) async {
    final file = await _getLocalFile(profileFileName);
    return file.writeAsString(jsonEncode(json));
  }

  @override
  Future<File> getProfileFile() async {
    var exists = await profileFileExists();
    if (!exists) {
      // save empty dummy file so we don't run into file not found exceptions
      await saveProfileFile('');
    }
    final file = await _getLocalFile(profileFileName);
    return file;
  }

  @override
  Future<bool> profileFileExists() async {
    final file = await _getLocalFile(profileFileName);
    return file.exists();
  }

  @override
  Future<File> getImageMappingFile() async {
    var exists = await imageMappingFileExists();
    if (!exists) {
      // save empty dummy file so we don't run into file not found exceptions
      await saveImageMappingFile('');
    }
    final file = await _getLocalFile(imageMappingFileName);
    return file;
  }

  @override
  Future<bool> imageMappingFileExists() async {
    final file = await _getLocalFile(imageMappingFileName);
    return file.exists();
  }

  @override
  Future<File> saveImageMappingFile(json) async {
    final file = await _getLocalFile(imageMappingFileName);
    return file.writeAsString(jsonEncode(json));
  }

  @override
  Future<bool> fileExists(String path) async {
    final file = File(path);
    return file.exists();
  }

  @override
  Future<String> getImageDirectory() async {
    String path = await _localPath;
    return '$path/$imageSubdirectory';
  }

  @override
  Future<String> getTempDirectory() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }
}
