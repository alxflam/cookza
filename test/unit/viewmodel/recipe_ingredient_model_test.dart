import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/recipe_creator.dart';

void main() {
  var mock = MockRecipeManager();

  setUpAll(() {
    GetIt.I.registerSingleton<RecipeManager>(mock);
  });

  test('Supports no recipe reference', () async {
    var cut = RecipeIngredientModel.empty(false);
    expect(cut.supportsRecipeReference, false);
  });

  test('Supports recipe reference', () async {
    var cut = RecipeIngredientModel.empty(true);
    expect(cut.supportsRecipeReference, true);
  });

  test('Set recipe reference', () async {
    var cut = RecipeIngredientModel.empty(true);
    var recipe = RecipeCreator.createRecipe('Test');
    when(mock.getRecipeById(['1234']))
        .thenAnswer((_) => Future.value([recipe]));
    await cut.setRecipeReference('1234');
    var model = cut.recipe;
    expect(model != null, true);
    expect(model!.recipe, recipe);
  });
}
