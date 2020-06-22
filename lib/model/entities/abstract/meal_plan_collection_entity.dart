import 'dart:collection';

import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/user_entity.dart';

abstract class MealPlanCollectionEntity {
  String get id;
  String get name;
  DateTime get creationTimestamp;
  UnmodifiableListView<UserEntity> get users;
  MealPlanEntity get mealPlan;
}
