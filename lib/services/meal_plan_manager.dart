import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';

abstract class MealPlanManager {
  Future<MealPlanEntity> get mealPlan;

  String get currentCollection;
  set currentCollection(String value);
  Future<void> createCollection(String name);
  Future<void> renameCollection(String name, MealPlanCollectionEntity entity);

  Stream<List<MealPlanCollectionEntity>> get collectionsAsStream;
  Future<void> saveMealPlan(MealPlanEntity entity);
  Future<void> addUserToCollection(
      MealPlanCollectionEntity entity, String userID, String name);
  Future<void> deleteCollection(MealPlanCollectionEntity entity);

  Future<void> leaveGroup(MealPlanCollectionEntity entity);
}

class MealPlanManagerFirebase implements MealPlanManager {
  String documentID;
  String _currentCollection;

  @override
  Future<MealPlanEntity> get mealPlan async {
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
  Future<void> deleteCollection(MealPlanCollectionEntity entity) {
    return sl.get<FirebaseProvider>().deleteMealPlanCollection(entity.id);
  }

  @override
  Future<void> leaveGroup(MealPlanCollectionEntity entity) {
    return sl.get<FirebaseProvider>().leaveMealPlanGroup(entity.id);
  }
}
