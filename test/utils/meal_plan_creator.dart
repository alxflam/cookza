import 'package:cookly/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/service_locator.dart';

class MealPlanCreator {
  static MutableMealPlan createMealPlan(String name, int weeks) {
    var doc = FirebaseMealPlanDocument(items: []);
    doc.groupID = sl.get<IdGenerator>().id;
    doc.documentID = sl.get<IdGenerator>().id;
    var entity = MealPlanEntityFirebase.of(doc);
    return MutableMealPlan.of(entity, weeks);
  }
}
