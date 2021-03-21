import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/screens/groups/abstract_group.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:cookza/viewmodel/groups/meal_plan_group_model.dart';

class MealPlanGroupScreen extends AbstractGroupScreen {
  static final String id = 'mealPlanGroup';

  @override
  GroupViewModel buildGroupViewModel(Object arguments) {
    assert(arguments is MealPlanCollectionEntity);
    return MealPlanGroupViewModel.of(arguments as MealPlanCollectionEntity);
  }
}
