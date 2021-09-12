import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/screens/groups/abstract_group.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:cookza/viewmodel/groups/recipe_group_model.dart';
import 'package:flutter/material.dart';

class RecipeGroupScreen extends AbstractGroupScreen {
  static const String id = 'recipeGroup';

  const RecipeGroupScreen({Key? key}) : super(key: key);

  @override
  GroupViewModel buildGroupViewModel(Object arguments) {
    assert(arguments is RecipeCollectionEntity);
    return RecipeGroupViewModel.of(arguments as RecipeCollectionEntity);
  }
}
