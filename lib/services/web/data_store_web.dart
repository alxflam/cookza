import 'dart:convert';
import 'dart:io';

import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/image_map.dart';
import 'dart:html' as html;

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDataStore implements DataStore {
  AppProfile _appProfile;

  static const String PREF_KEY = 'APP_PROFILE';

  Future<DataStore> init() async {
    // in future, maybe web storage is supported by flutter
    // then local storage could be used also on the web build
    await load;
    return this;
  }

  @override
  AppProfile get appProfile => _appProfile;

  Future<AppProfile> get load async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = prefs.getString(PREF_KEY);
    if (result != null && result.isNotEmpty && result.length > 10) {
      print('loaded profile from prefs with $result');
      var profile = this._decodeProfile(result);
      this._appProfile = AppProfile(profile);
    } else {
      var profile = Profile(recipeList: RecipeList(recipes: []));
      this._appProfile = AppProfile(profile);
    }
    return this._appProfile;
  }

  Profile _decodeProfile(String contents) {
    try {
      var decodedJson = jsonDecode(contents);
      return Profile.fromJson(decodedJson);
    } catch (e) {
      print('json parsing error');
      return Profile(recipeList: RecipeList());
    }
  }

  @override
  void save(Profile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = profile.toJson();
    var encodedProfile = jsonEncode(json);
    print('saved profile with: $encodedProfile');
    prefs.setString(PREF_KEY, encodedProfile);
  }

  @override
  Future<List<LocalImage>> getImageMapping() {
    List<LocalImage> result = [];
    return Future.value(result);
  }

  @override
  Future saveImageMapping(List<LocalImage> images) {}

  @override
  Future<Map<String, String>> copyImages(Map<String, File> images) {}

  @override
  void exportRecipes(List<String> ids) {
    List<Recipe> selected = [];
    for (var recipe in this.appProfile.profile.recipeList.recipes) {
      if (ids.contains(recipe.id)) {
        selected.add(recipe);
      }
    }

    var result = Profile(recipeList: RecipeList(recipes: selected));

    var json = result.toJson();
    var exportJson = jsonEncode(json);

    final bytes = utf8.encode(exportJson);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'cooklyExport.json';
    html.document.body.children.add(anchor);

    // trigger downlaod
    anchor.click();

    // remove DOM element
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  void importRecipes(List<Recipe> recipes) {
    for (var recipe in recipes) {
      this.appProfile.addOrUpdateRecipe(recipe);
    }
  }

  @override
  Future<List<Recipe>> getRecipesFromJsonFile() async {
    // configure file selection dialog
  }

  @override
  Future<void> deleteImage(String id) {
    // TODO: implement deleteImage
    throw UnimplementedError();
  }
}
