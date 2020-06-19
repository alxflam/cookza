import 'dart:collection';

import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/entities/firebase/user_entity.dart';
import 'package:cookly/model/firebase/general/firebase_user.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';

class MealPlanDateEntityFirebase implements MealPlanDateEntity {
  DateTime _date;
  List<MealPlanRecipeEntity> _recipes;

  MealPlanDateEntityFirebase.of(FirebaseMealPlanDate item) {
    this._date = item.date;
    this._recipes =
        item.recipes.map((e) => MealPlanRecipeEntityFirebase.of(e)).toList();
  }

  @override
  DateTime get date => this._date;

  @override
  List<MealPlanRecipeEntity> get recipes => this._recipes;
}

class MealPlanRecipeEntityFirebase implements MealPlanRecipeEntity {
  String _id;
  String _name;
  int _servings;

  MealPlanRecipeEntityFirebase.of(FirebaseMealPlanRecipe item) {
    this._id = item.id;
    this._name = item.name;
    this._servings = item.servings;
  }

  @override
  String get id => this._id;

  @override
  String get name => this._name;

  @override
  int get servings => this._servings;
}

class MealPlanEntityFirebase implements MealPlanEntity {
  List<MealPlanDateEntity> _items;
  UnmodifiableListView<UserEntity> _users;
  String _id;

  MealPlanEntityFirebase.of(FirebaseMealPlanDocument document) {
    this._id = document.documentID;
    this._items =
        document.items.map((e) => MealPlanDateEntityFirebase.of(e)).toList();
    this._users = UnmodifiableListView(document.users.entries
        .map((e) => UserEntityFirebase.from(
              FirebaseRecipeUser(id: e.key, name: e.value),
            ))
        .toList());
  }

  @override
  List<MealPlanDateEntity> get items => this._items;

  @override
  UnmodifiableListView<UserEntity> get users => this._users;

  @override
  String get id => this._id;
}
