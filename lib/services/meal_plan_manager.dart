import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';

abstract class MealPlanManager {
  Future<MealPlanEntity> get mealPlan;
  Future<void> saveMealPlan(MealPlanEntity entity);
  Future<void> addUser(String userID, String name);
}

class MealPlanManagerFirebase implements MealPlanManager {
  String documentID;

  @override
  Future<MealPlanEntity> get mealPlan async {
    var result = await sl.get<FirebaseProvider>().mealPlan();
    documentID = result.id;
    return result;
  }

  @override
  Future<void> saveMealPlan(MealPlanEntity entity) async {
    documentID = await sl.get<FirebaseProvider>().saveMealPlan(entity);
  }

  @override
  Future<void> addUser(String userID, String name) {
    if (documentID == null || documentID.isEmpty) {
      throw 'MealPlan has not yet been initialized!';
    }

    return sl
        .get<FirebaseProvider>()
        .addUserToMealPlan(documentID, userID, name);
  }
}
