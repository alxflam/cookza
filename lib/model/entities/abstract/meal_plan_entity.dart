import 'dart:collection';

import 'package:cookly/model/entities/abstract/user_entity.dart';

abstract class MealPlanDateEntity {
  DateTime get date;

  List<MealPlanRecipeEntity> get recipes;
}

abstract class MealPlanRecipeEntity {
  String get name;
  String get id;
  int get servings;
}

abstract class MealPlanEntity {
  String get id;

  UnmodifiableListView<UserEntity> get users;

  List<MealPlanDateEntity> get items;
}
