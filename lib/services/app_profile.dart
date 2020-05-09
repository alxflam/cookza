import 'dart:collection';
import 'dart:io';

import 'package:cookly/model/json/image_map.dart';
import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

class AppProfile extends ChangeNotifier {
  Profile _profile;

  AppProfile(this._profile);

  void addOrUpdateRecipe(Recipe recipe) {
    this
        ._profile
        .recipeList
        .recipes
        .removeWhere((element) => element.id == recipe.id);
    this._profile.recipeList.recipes.add(recipe);
    sl.get<DataStore>().save(_profile);
    notifyListeners();
  }

  Profile get profile => _profile;

  void deleteRecipe(String id) {
    this._profile.recipeList.recipes.removeWhere((element) => element.id == id);
    sl.get<DataStore>().save(_profile);
    // todo delete the leftover image: make a settings screen to show all images for checking purposes
    notifyListeners();
  }

  int get countRecipes {
    return this._profile?.recipeList?.recipes?.length;
  }

  String get lastAddedRecipe {
    return 'not implemented';
  }

  String get lastPlannedRecipe {
    return 'not implemented';
  }

  UnmodifiableListView<RecipeViewModel> get recipes {
    List<RecipeViewModel> result =
        _profile.recipeList.recipes.map((f) => getRecipeById(f.id)).toList();
    return UnmodifiableListView(result);
  }

  RecipeViewModel getRecipeById(String id) {
    Recipe recipe = this
        ._profile
        .recipeList
        .recipes
        .firstWhere((item) => item.id == id, orElse: () => null);
    return RecipeViewModel.of(recipe);
  }

  Future<FileImage> getRecipeImage(String id) async {
    Recipe recipe = this
        ._profile
        .recipeList
        .recipes
        .firstWhere((item) => item.id == id, orElse: () => null);
    if (recipe != null) {
      List<LocalImage> images = await sl.get<DataStore>().getImageMapping();
      LocalImage imageMapping = images.firstWhere(
          (item) => item.recipeReference == recipe.id,
          orElse: () => null);
      if (imageMapping != null && imageMapping.imageFilePath != null) {
        bool exists = await sl
            .get<StorageProvider>()
            .fileExists(imageMapping?.imageFilePath);
        if (exists) {
          /// todo let the storage provider return the image directly
          return FileImage(File(imageMapping.imageFilePath));
        }
      }
    }
    return null;
  }

  Future<void> addImage({File file, String id}) async {
    Map<String, File> imageMap = {
      id: file,
    };

    Map<String, String> imageMapping =
        await sl.get<DataStore>().copyImages(imageMap);

    List<LocalImage> result = await sl.get<DataStore>().getImageMapping();
    for (var entry in imageMapping.entries) {
      result.add(LocalImage(entry.key, entry.value));
    }

    await sl.get<DataStore>().saveImageMapping(result);
  }

  List<Recipe> getRawRecipes(List<String> ids) {
    List<Recipe> result = [];
    for (var recipe in this.profile.recipeList.recipes) {
      if (ids.contains(recipe.id)) {
        result.add(recipe);
      }
    }
    return result;
  }
}
