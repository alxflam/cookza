import 'dart:collection';

import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/entities/firebase/user_entity.dart';
import 'package:cookly/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/model/firebase/general/firebase_user.dart';

class MealPlanCollectionEntityFirebase implements MealPlanCollectionEntity {
  FirebaseMealPlanCollection _collection;

  MealPlanCollectionEntityFirebase.of(FirebaseMealPlanCollection collection) {
    this._collection = collection;
  }

  @override
  DateTime get creationTimestamp => _collection.creationTimestamp.toDate();

  @override
  String get id => _collection.documentID;

  @override
  MealPlanEntity get mealPlan => throw UnimplementedError();

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
