import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/recipe_manager_mock.dart';
import '../../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<RecipeManager>(RecipeManagerMock());
  });

  test('Refresh model', () async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.rating = 3;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.addTag('vegetarian');

    var cut = RecipeViewModel.of(recipe);

    recipe.name = 'Something else';
    cut.refreshFrom(recipe);
    expect(cut.name, 'Something else');
  });

  test('Set rating', () async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.rating = 3;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.addTag('vegetarian');

    var cut = RecipeViewModel.of(recipe);
    expect(cut.rating, 3);

    await cut.setRating(5);
    expect(cut.rating, 5);
  });

  test('Getter - Difficulty', () async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.rating = 3;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.addTag('vegetarian');

    var cut = RecipeViewModel.of(recipe);
    expect(cut.difficulty, DIFFICULTY.HARD);
  });
}