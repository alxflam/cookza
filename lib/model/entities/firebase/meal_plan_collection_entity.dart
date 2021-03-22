import 'dart:collection';

import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/user_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/firebase/general/firebase_user.dart';

class MealPlanCollectionEntityFirebase implements MealPlanCollectionEntity {
  final FirebaseMealPlanCollection _collection;

  MealPlanCollectionEntityFirebase.of(this._collection);

  @override
  DateTime get creationTimestamp => _collection.creationTimestamp.toDate();

  @override
  String? get id => _collection.documentID;

  @override
  String get name => _collection.name;

  @override
  UnmodifiableListView<UserEntity> get users {
    return UnmodifiableListView(this
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
}
