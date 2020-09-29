import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:flutter/material.dart';

class MealPlanGroupViewModel with ChangeNotifier implements GroupViewModel {
  MealPlanCollectionEntity _entity;

  String _name;

  MealPlanGroupViewModel.of(MealPlanCollectionEntity entity) {
    this._entity = entity;
    this._name = entity.name;
  }

  MealPlanCollectionEntity get entity => this._entity;

  @override
  Future<void> rename(String value) async {
    await sl.get<MealPlanManager>().renameCollection(value, this._entity);
    this._name = value;
    notifyListeners();
  }

  @override
  String get name {
    return _name;
  }

  @override
  Future<void> addUser(String userID, String name) async {
    await sl.get<MealPlanManager>().addUserToCollection(this.entity, userID,
        name == null || name.isEmpty ? 'unknown user' : name);

    notifyListeners();
  }

  @override
  Future<void> leaveGroup() async {
    await sl.get<MealPlanManager>().leaveGroup(this.entity);
  }

  @override
  Future<void> delete() {
    return sl.get<MealPlanManager>().deleteCollection(this.entity);
  }

  @override
  Future<List<UserEntity>> members() {
    return Future.value(entity.users);
  }

  @override
  Future<void> removeMember(UserEntity user) async {
    await sl.get<MealPlanManager>().removeMember(user, entity.id);
    this._entity = await sl.get<MealPlanManager>().getCollectionByID(entity.id);
    notifyListeners();
  }
}
