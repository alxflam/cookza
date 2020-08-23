import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/screens/groups/abstract_group.dart';
import 'package:cookly/viewmodel/groups/abstract_group_model.dart';
import 'package:cookly/viewmodel/groups/meal_plan_group_model.dart';

class MealPlanGroupScreen extends AbstractGroupScreen {
  static final String id = 'mealPlanGroup';

  @override
  GroupViewModel buildGroupViewModel(Object arguments) {
    assert(arguments is MealPlanCollectionEntity);
    return MealPlanGroupViewModel.of(arguments);
  }
}
