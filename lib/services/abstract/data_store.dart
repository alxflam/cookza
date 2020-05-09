import 'dart:io';

import 'package:cookly/model/json/image_map.dart';
import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/services/app_profile.dart';

abstract class DataStore {
  Future<AppProfile> get load;

  AppProfile get appProfile;

  void save(Profile profile);

  Future<List<LocalImage>> getImageMapping();

  Future saveImageMapping(List<LocalImage> images);

  Future<Map<String, String>> copyImages(Map<String, File> images);

  void importRecipes(List<Recipe> recipes);

  Future<List<Recipe>> getRecipesFromJsonFile();
}
