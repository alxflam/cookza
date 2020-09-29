import 'dart:collection';

import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/recipe_collection.dart';

class RecipeCollectionEntityJson implements RecipeCollectionEntity {
  RecipeCollection _collection;

  RecipeCollectionEntityJson.of(RecipeCollection collection) {
    this._collection = collection;
  }

  @override
  DateTime get creationTimestamp => this._collection.creationTimestamp.toDate();

  @override
  String get id => this._collection.id;

  @override
  String get name => this._collection.name;

  @override
  UnmodifiableListView<UserEntity> get users => UnmodifiableListView([]);
}
