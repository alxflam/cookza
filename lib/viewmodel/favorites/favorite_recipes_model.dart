import 'dart:async';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';

class FavoriteRecipesViewModel with ChangeNotifier {
  int _minRating = 1;

  final recipeManager = sl.get<RecipeManager>();

  final List<RecipeEntity> favorites;

  bool _initialized = false;

  FavoriteRecipesViewModel({required this.favorites});

  List<RecipeEntity> getFavoriteRecipes() {
    // if (!_initialized) {
    //   favorites = sl.get<RecipeManager>().getFavoriteRecipes()
    // }
    return favorites.where((e) => shouldAdd(e)).toList();

    // return Stream.fromIterable(favorites).transform(
    //   StreamTransformer.fromHandlers(
    //     handleData: (data, sink) {
    //       if (shouldAdd(data)) {
    //         sink.add([data]);
    //       }
    //     },
    //   ),
    // );
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
