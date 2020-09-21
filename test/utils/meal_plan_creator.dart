import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/service_locator.dart';

class MealPlanCreator {
  static MutableMealPlan createMealPlan(String name, int weeks) {
    var groupID = sl.get<IdGenerator>().id;
    var documentID = sl.get<IdGenerator>().id;
    return MutableMealPlan.of(groupID, documentID, [], weeks);
  }
}
