import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/services/util/id_gen.dart';
import 'package:cookza/services/flutter/service_locator.dart';

class MealPlanCreator {
  static MutableMealPlan createMealPlan(String name, int weeks) {
    var groupID = sl.get<IdGenerator>().id;
    var documentID = sl.get<IdGenerator>().id;
    return MutableMealPlan.of(groupID, documentID, [], weeks);
  }
}
