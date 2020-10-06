import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';

abstract class MealPlanManager {
  Future<MealPlanEntity> get mealPlan;

  String get currentCollection;
  set currentCollection(String value);
  Future<void> createCollection(String name);
  Future<void> renameCollection(String name, MealPlanCollectionEntity entity);
  Future<MealPlanCollectionEntity> getCollectionByID(String id);

  Future<List<MealPlanCollectionEntity>> get collections;

  Stream<List<MealPlanCollectionEntity>> get collectionsAsStream;
  Future<void> saveMealPlan(MealPlanEntity entity);
  Future<void> addUserToCollection(
      MealPlanCollectionEntity entity, String userID, String name);
  Future<void> deleteCollection(MealPlanCollectionEntity entity);

  Future<void> leaveGroup(MealPlanCollectionEntity entity);

  Future<MealPlanEntity> getMealPlanByCollectionID(String id);

  Future<void> init();

  Future<void> removeMember(UserEntity user, String mealPlan);
}

class MealPlanManagerFirebase implements MealPlanManager {
  String documentID;
  String _currentCollection;

  @override
  Future<MealPlanEntity> get mealPlan async {
    if (currentCollection == null || currentCollection.isEmpty) {
      return Future.value(null);
    }
    var result = await sl.get<FirebaseProvider>().mealPlan(currentCollection);
    documentID = result.id;
    return result;
  }

  @override
  Future<void> saveMealPlan(MealPlanEntity entity) async {
    documentID = await sl.get<FirebaseProvider>().saveMealPlan(entity);
  }

  @override
  Stream<List<MealPlanCollectionEntity>> get collectionsAsStream {
    return sl.get<FirebaseProvider>().mealPlanGroups;
  }

  @override
  String get currentCollection {
    return _currentCollection;
  }

  @override
  Future<void> createCollection(String name) {
    return sl.get<FirebaseProvider>().createMealPlanGroup(name);
  }

  @override
  set currentCollection(String value) {
    _currentCollection = value;
    sl.get<SharedPreferencesProvider>().setCurrentMealPlanCollection(value);
  }

  @override
  Future<void> renameCollection(String name, MealPlanCollectionEntity entity) {
    return sl.get<FirebaseProvider>().renameMealPlanCollection(name, entity);
  }

  @override
  Future<void> addUserToCollection(
      MealPlanCollectionEntity entity, String userID, String name) {
    return sl
        .get<FirebaseProvider>()
        .addUserToMealPlanCollection(entity, userID, name);
  }

  @override
  Future<void> deleteCollection(MealPlanCollectionEntity entity) async {
    var firebase = sl.get<FirebaseProvider>();
    var group = await getCollectionByID(entity.id);
    if (group.users.where((e) => e.id != firebase.userUid).isNotEmpty) {
      throw 'Can\'t delete group with members';
    }
    return firebase.deleteMealPlanCollection(entity.id);
  }

  @override
  Future<void> leaveGroup(MealPlanCollectionEntity entity) {
    return sl.get<FirebaseProvider>().leaveMealPlanGroup(entity.id);
  }

  @override
  Future<MealPlanCollectionEntity> getCollectionByID(String id) {
    return sl.get<FirebaseProvider>().getMealPlanGroupByID(id);
  }

  @override
  Future<List<MealPlanCollectionEntity>> get collections {
    return sl.get<FirebaseProvider>().mealPlanGroupsAsList;
  }

  @override
  Future<MealPlanEntity> getMealPlanByCollectionID(String id) {
    return sl.get<FirebaseProvider>().getMealPlanByID(id);
  }

  @override
  Future<void> init() {
    this._currentCollection =
        sl.get<SharedPreferencesProvider>().getCurrentMealPlanCollection();
    return Future.value(this._currentCollection);
  }

  @override
  Future<void> removeMember(UserEntity user, String mealPlan) {
    return sl.get<FirebaseProvider>().removeFromMealPlan(user, mealPlan);
  }
}
