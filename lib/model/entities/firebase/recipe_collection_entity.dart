import 'dart:collection';

import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/user_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookza/model/firebase/general/firebase_user.dart';

class RecipeCollectionEntityFirebase implements RecipeCollectionEntity {
  final FirebaseRecipeCollection _collection;

  RecipeCollectionEntityFirebase.of(this._collection);

  @override
  DateTime get creationTimestamp => this._collection.creationTimestamp.toDate();

  @override
  String? get id => this._collection.documentID;

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
