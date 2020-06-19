import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';

abstract class MealPlanManager {
  Future<MealPlanEntity> get mealPlan;
}

class MealPlanManagerFirebase implements MealPlanManager {
  @override
  Future<MealPlanEntity> get mealPlan async {
    return sl.get<FirebaseProvider>().mealPlan();
  }
}
