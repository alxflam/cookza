import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';

import 'id_gen.dart';

class MealPlanCreator {
  static MutableMealPlan createMealPlan(String name, int weeks) {
    var groupID = UniqueKeyIdGenerator().id;
    var documentID = UniqueKeyIdGenerator().id;
    return MutableMealPlan.of(groupID, documentID, [], weeks);
  }
}
