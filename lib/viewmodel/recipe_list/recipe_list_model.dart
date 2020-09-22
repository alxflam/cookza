import 'dart:async';

import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';

class RecipeListViewModel with ChangeNotifier {
  String _filterString;

  var _searchEnabled = false;

  Stream<List<RecipeEntity>> getRecipes() {
    return sl
        .get<RecipeManager>()
        .recipes
        .transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        List<RecipeEntity> toBeAdded = [];

        for (var item in data) {
          if (shouldAdd(item)) {
            toBeAdded.add(item);
          }
          sink.add(toBeAdded);
        }
      },
    ));
  }

  set filterString(String value) {
    this._filterString = value;
    notifyListeners();
  }

  String get filterString => this._filterString;

  bool get isSearchEnabled => this._searchEnabled;

  set isSearchEnabled(bool value) {
    if (value != this._searchEnabled) {
      this._filterString = null;
      this._searchEnabled = value;
      notifyListeners();
    }
  }

  bool shouldAdd(RecipeEntity item) {
    if (this._filterString == null || this._filterString.trim().isEmpty) {
      return true;
    }
    return item.name.toLowerCase().contains(this._filterString.toLowerCase());
  }
}
