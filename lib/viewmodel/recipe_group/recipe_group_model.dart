import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

class RecipeGroupViewModel with ChangeNotifier {
  RecipeCollectionEntity _entity;

  String _name;

  RecipeGroupViewModel.of(RecipeCollectionEntity entity) {
    this._entity = entity;
    this._name = entity.name;
  }

  RecipeCollectionEntity get entity => this._entity;

  Future<void> rename(String value) async {
    await sl.get<RecipeManager>().renameCollection(value, this._entity);
    this._name = value;
    notifyListeners();
  }

  String get name {
    return _name;
  }
}
