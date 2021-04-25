import 'dart:async';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';

class FavoriteRecipesViewModel with ChangeNotifier {
  /// initially only show the highes rated recipes
  int _minRating = 5;

  final recipeManager = sl.get<RecipeManager>();

  List<RecipeEntity> favorites = [];

  bool _initialized = false;

  Future<List<RecipeEntity>> getFavoriteRecipes() async {
    /// only load the favorites once and cache them
    /// to prevent loading them again when the user changes the rating filter
    if (!_initialized) {
      favorites = await recipeManager.getFavoriteRecipes();
      _initialized = true;
    }
    return favorites.where((e) => shouldAdd(e)).toList();
  }

  set minRating(int value) {
    this._minRating = value;
    notifyListeners();
  }

  int get minRating => this._minRating;

  bool shouldAdd(RecipeEntity item) {
    // we can safely assume the ratings are now cached as retriving the favorites caches the ratings
    final rating = recipeManager.getCachedRating(item) ?? 0;
    if (rating >= this._minRating) {
      return true;
    }
    return false;
  }
}
