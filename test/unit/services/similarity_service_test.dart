import 'dart:collection';

import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/recipe/similarity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/recipe_manager_mock.dart';
import '../../utils/recipe_creator.dart';

void main() {
  var mock = RecipeManagerStub();
  GetIt.I.registerSingleton<RecipeManager>(mock);
  var cut = SimilarityService();

  setUp(() {
    mock.reset();
  });

  test('testRecipesContainingIngredientIsNotCaseSensitive', () async {
    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');

    recipe.ingredientList = [pepper];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getRecipesContaining(['pEppER']);

    expect(result.length, 1);
  });

  test('testRecipesContainingIngredientWithMultipleIngredients', () async {
    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');

    recipe.ingredientList = [pepper, onion, tomato];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getRecipesContaining(['pEppER', 'tomato', 'ONION']);

    expect(result.length, 1);
  });

  test('testContainsIngredient', () async {
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');

    var ingredientList = UnmodifiableListView([pepper, onion, tomato]);

    var result = cut.containsIngredient(ingredientList, 'onion');

    expect(result, true);
  });

  test('testContainsNotIngredient', () async {
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');

    var ingredientList = UnmodifiableListView([pepper, onion, tomato]);
    var result = cut.containsIngredient(ingredientList, 'salt');

    expect(result, false);
  });

  test('testSimilarRecipesReturnsNotSelf', () async {
    MutableRecipe recipe = RecipeCreator.createRecipe('dummy');

    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');

    recipe.ingredientList = [pepper, onion, tomato];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 0);
  });

  test('testSimilarRecipesThresholdNotReached', () async {
    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');
    var salad = RecipeCreator.createIngredient('Salad');
    recipe.ingredientList = [pepper, onion, tomato, salad];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var secondRecipe = RecipeCreator.createRecipe('dummy 2');
    secondRecipe.ingredientList = [pepper];

    GetIt.I.get<RecipeManager>().createOrUpdate(secondRecipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 0);
  });

  test('testSimilarRecipesThresholdReached', () async {
    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('Onion');
    var tomato = RecipeCreator.createIngredient('Tomato');
    var salad = RecipeCreator.createIngredient('Salad');
    recipe.ingredientList = [pepper, onion, tomato, salad];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);
    var goatCheese = RecipeCreator.createIngredient('Goat Cheese');
    var secondRecipe = RecipeCreator.createRecipe('dummy 2');

    secondRecipe.ingredientList = [pepper, salad, goatCheese];

    GetIt.I.get<RecipeManager>().createOrUpdate(secondRecipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 1);
  });
}
