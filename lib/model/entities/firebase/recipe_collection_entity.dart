import 'dart:collection';

import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/entities/firebase/user_entity.dart';
import 'package:cookly/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookly/model/firebase/general/firebase_user.dart';

class RecipeCollectionEntityFirebase implements RecipeCollectionEntity {
  FirebaseRecipeCollection _collection;

  RecipeCollectionEntityFirebase.of(FirebaseRecipeCollection collection) {
    this._collection = collection;
  }

  @override
  DateTime get creationTimestamp => this._collection.creationTimestamp.toDate();

  @override
  String get id => this._collection.documentID;

  @override
  String get name => this._collection.name;

  @override
  UnmodifiableListView<UserEntity> get users => UnmodifiableListView(this
      ._collection
      .users
      .entries
      .map(
        (e) => UserEntityFirebase.from(
          FirebaseRecipeUser(id: e.key, name: e.value),
        ),
      )
      .toList());
}