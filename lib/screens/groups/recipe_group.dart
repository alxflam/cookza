import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/screens/groups/abstract_group.dart';
import 'package:cookly/viewmodel/groups/abstract_group_model.dart';
import 'package:cookly/viewmodel/groups/recipe_group_model.dart';

class RecipeGroupScreen extends AbstractGroupScreen {
  static final String id = 'recipeGroup';

  @override
  GroupViewModel buildGroupViewModel(Object arguments) {
    assert(arguments is RecipeCollectionEntity);
    return RecipeGroupViewModel.of(arguments);
  }
}
