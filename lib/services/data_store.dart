// import 'dart:convert';
// import 'dart:io';

// import 'package:cookly/model/entities/abstract/recipe_entity.dart';
// import 'package:cookly/model/json/image_map.dart';
// import 'package:cookly/model/json/profile.dart';
// import 'package:cookly/model/json/recipe.dart';
// import 'package:cookly/model/json/recipe_list.dart';
// import 'package:cookly/services/abstract/data_store.dart';
// import 'package:cookly/services/app_profile.dart';
// import 'package:cookly/services/local_storage.dart';
// import 'package:cookly/services/service_locator.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path/path.dart';

// class LocalStorageDataStore implements DataStore {
//   AppProfile profile;

//   Future<DataStore> init() async {
//     await load;
//     return this;
//   }

//   Profile _decodeProfile(String contents) {
//     try {
//       var decodedJson = jsonDecode(contents);
//       return Profile.fromJson(decodedJson);
//     } catch (e) {
//       print('json parsing error');
//       return Profile(recipeList: RecipeList());
//     }
//   }

//   /// lazy loading app data
//   @override
//   Future<AppProfile> get load async {
//     print('load called');

//     if (this.profile == null) {
//       File file = await sl.get<StorageProvider>().getProfileFile();
//       String contents = await file.readAsString();
//       Profile profile;
//       if (contents.isNotEmpty && contents.length > 5) {
//         profile = _decodeProfile(contents);
//       } else {
//         // otherwise create a new blank profile
//         profile = Profile(recipeList: RecipeList(recipes: []));
//         await this.save(profile);
//       }
//       this.profile = AppProfile(profile);
//     }
//     return this.profile;
//   }

//   @override
//   Future<void> save(Profile profile) async {
//     File file = await sl.get<StorageProvider>().getProfileFile();
//     var json = profile.toJson();
//     await file.writeAsString(jsonEncode(json));
//     print('profile saved at ${file.path}');
//   }

//   /// todo cache the image map
//   @override
//   Future<List<LocalImage>> getImageMapping() async {
//     File file = await sl.get<StorageProvider>().getImageMappingFile();
//     String contents = await file.readAsString();
//     LocalImageList result;
//     if (contents.isNotEmpty && contents.length > 5) {
//       //if there's some content in the json, decode it
//       var decodedJson = jsonDecode(contents);
//       result = LocalImageList.fromJson(decodedJson);
//     } else {
//       // otherwise create a new blank profile
//       result = LocalImageList([]);
//     }
//     return result.images;
//   }

//   @override
//   AppProfile get appProfile {
//     return this.profile;
//   }

//   @override
//   Future<void> saveImageMapping(List<LocalImage> images) async {
//     File file = await sl.get<StorageProvider>().getImageMappingFile();
//     var json = LocalImageList(images).toJson();
//     await file.writeAsString(jsonEncode(json));
//     print('image mapping saved at ${file.path}');
//   }

//   @override
//   Future<Map<String, String>> copyImages(Map<String, File> images) async {
//     String path = await sl.get<StorageProvider>().getImageDirectory();
//     Map<String, String> result = {};
//     for (var entry in images.entries) {
//       String fileExtension = extension(entry.value.path);
//       // check if that occurs for unsaved camera pictures
//       if (fileExtension == null) {
//         fileExtension = '.jpg';
//       }
//       String targetPath = '$path/${entry.key}$fileExtension';
//       var target = File(targetPath);
//       if (!target.existsSync()) {
//         // recursive creates the parent image directory if it does not yet exist
//         File(targetPath).createSync(recursive: true);
//       }
//       // File targetFile = await entry.value.copy(targetPath);
//       // bool exists = await targetFile.exists();
//       // if (!exists) {
//       //   throw 'image could not be saved!';
//       // }
//       target.writeAsBytesSync(entry.value.readAsBytesSync(), flush: true);
//       print('image saved at ${target.path}');
//       result.putIfAbsent(entry.key, () => targetPath);
//     }
//     return result;
//   }

//   Future<void> deleteImage(String id) async {
//     String path = await sl.get<StorageProvider>().getImageDirectory();
//     // TODO: could it be other extensions...?
//     String fileExtension = '.jpg';
//     String targetPath = '$path/${id}$fileExtension';
//     var file = File(targetPath);
//     if (file.existsSync()) {
//       file.deleteSync();
//     }
//   }

// // todo: rework import recipes from json to upload to firestore
//   @override
//   void importRecipes(List<RecipeEntity> recipes) async {
//     for (var recipe in recipes) {
//       // this.appProfile.addOrUpdateRecipe(recipe);
//     }
//   }

//   @override
//   Future<List<Recipe>> getRecipesFromJsonFile() async {
//     var file = await FilePicker.getFile(
//       type: FileType.custom,
//       allowedExtensions: ['json'],
//     );
//     List<Recipe> result = [];
//     if (file == null) {
//       return result; // no file selected
//     }
//     if (!file.existsSync()) {
//       throw "The selected file does not exist";
//     }
//     var content = file.readAsStringSync();
//     Profile profile = _decodeProfile(content);
//     for (var item in profile.recipeList.recipes) {
//       result.add(item);
//     }
//     return result;
//   }
// }
