import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cookly/constants.dart';
import 'package:cookly/model/json/image_map.dart';
import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';

abstract class DataStore {
  Future<AppProfile> get load;

  AppProfile get appProfile;

  void save(Profile profile);

  Future<List<LocalImage>> getImageMapping();

  Future saveImageMapping(List<LocalImage> images);

  Future<Map<String, String>> copyImages(Map<String, File> images);

  void exportRecipes(List<String> ids);

  void importRecipes(List<Recipe> recipes);

  Future<List<Recipe>> getRecipesFromJsonFile();
}

class LocalStorageDataStore implements DataStore {
  AppProfile profile;

  Future<DataStore> init() async {
    await load;
    return this;
  }

  Profile _decodeProfile(String contents) {
    var decodedJson = jsonDecode(contents);
    return Profile.fromJson(decodedJson);
  }

  /// lazy loading app data
  @override
  Future<AppProfile> get load async {
    if (this.profile == null) {
      File file = await sl.get<StorageProvider>().getProfileFile();
      String contents = await file.readAsString();
      Profile profile;
      if (contents.isNotEmpty && contents.length > 5) {
        profile = await _decodeProfile(contents);
      } else {
        // otherwise create a new blank profile
        profile = Profile(recipes: []);
        await this.save(profile);
      }
      this.profile = AppProfile(profile);
    }
    return this.profile;
  }

  @override
  Future<void> save(Profile profile) async {
    File file = await sl.get<StorageProvider>().getProfileFile();
    var json = profile.toJson();
    await file.writeAsString(jsonEncode(json));
    print('profile saved at ${file.path}');
  }

  /// todo cache the image map
  @override
  Future<List<LocalImage>> getImageMapping() async {
    File file = await sl.get<StorageProvider>().getImageMappingFile();
    String contents = await file.readAsString();
    LocalImageList result;
    if (contents.isNotEmpty && contents.length > 5) {
      //if there's some content in the json, decode it
      var decodedJson = jsonDecode(contents);
      result = LocalImageList.fromJson(decodedJson);
    } else {
      // otherwise create a new blank profile
      result = LocalImageList([]);
    }
    return result.images;
  }

  @override
  AppProfile get appProfile {
    return this.profile;
  }

  @override
  Future<void> saveImageMapping(List<LocalImage> images) async {
    File file = await sl.get<StorageProvider>().getImageMappingFile();
    var json = LocalImageList(images).toJson();
    await file.writeAsString(jsonEncode(json));
    print('image mapping saved at ${file.path}');
  }

  @override
  Future<Map<String, String>> copyImages(Map<String, File> images) async {
    String path = await sl.get<StorageProvider>().getImageDirectory();
    Map<String, String> result = {};
    for (var entry in images.entries) {
      String fileExtension = extension(entry.value.path);
      // check if that occurs for unsaved camera pictures
      if (fileExtension == null) {
        fileExtension = '.jpg';
      }
      String targetPath = '$path/${entry.key}$fileExtension';
      File(targetPath).createSync(
          recursive:
              true); // recursive creates the parent image directory if it does not yet exist
      File targetFile = await entry.value.copy(targetPath);
      bool exists = await targetFile.exists();
      if (!exists) {
        throw 'image could not be saved!';
      }
      targetFile.writeAsBytesSync(entry.value.readAsBytesSync(), flush: true);
      print('image saved at ${targetFile.path}');
      result.putIfAbsent(entry.key, () => targetPath);
    }
    return result;
  }

  @override
  Future<void> exportRecipes(List<String> ids) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File(
        '$directory/cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}.json');

    List<Recipe> selected = [];
    for (var recipe in this.appProfile.profile.recipes) {
      if (ids.contains(recipe.id)) {
        selected.add(recipe);
      }
    }

    var result = Profile(recipes: selected);

    var json = result.toJson();
    await file.writeAsString(jsonEncode(json));
    print('profile saved at ${file.path}');

    ShareExtend.share(file.path, 'file');
  }

  @override
  void importRecipes(List<Recipe> recipes) async {
    for (var recipe in recipes) {
      this.appProfile.addOrUpdateRecipe(recipe);
    }
  }

  @override
  Future<List<Recipe>> getRecipesFromJsonFile() async {
    var file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    List<Recipe> result = [];
    if (file == null) {
      return result; // no file selected
    }
    if (!file.existsSync()) {
      throw "The selected file does not exist";
    }
    var content = file.readAsStringSync();
    Profile profile = await _decodeProfile(content);
    for (var item in profile.recipes) {
      result.add(item);
    }
    return result;
  }
}
