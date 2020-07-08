import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

class MealPlanGroupViewModel with ChangeNotifier {
  MealPlanCollectionEntity _entity;

  String _name;

  MealPlanGroupViewModel.of(MealPlanCollectionEntity entity) {
    this._entity = entity;
    this._name = entity.name;
  }

  MealPlanCollectionEntity get entity => this._entity;

  Future<void> rename(String value) async {
    await sl.get<MealPlanManager>().renameCollection(value, this._entity);
    this._name = value;
    notifyListeners();
  }

  String get name {
    return _name;
  }

  void addUser(String userID, String name) async {
    await sl.get<MealPlanManager>().addUserToCollection(this.entity, userID,
        name == null || name.isEmpty ? 'unknown user' : name);

    notifyListeners();
  }

  Future<void> leaveGroup() async {
    await sl.get<MealPlanManager>().leaveGroup(this.entity);
  }
}
