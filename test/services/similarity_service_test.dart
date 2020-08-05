import 'dart:collection';

import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'mocks/recipe_manager_mock.dart';

MutableIngredientNote _createIngredient(String name) {
  var pepper = MutableIngredientNote.empty();
  pepper.name = name;
  return pepper;
}

void main() {
  var mock = RecipeManagerMock();
  GetIt.I.registerSingleton<RecipeManager>(mock);
  var cut = SimilarityService();

  setUp(() {
    mock.reset();
  });

  test('testRecipesContainingIngredientIsNotCaseSensitive', () async {
    var recipe = _createRecipe();
    var pepper = _createIngredient('Pepper');

    recipe.ingredientList = [pepper];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getRecipesContaining(['pEppER']);

    expect(result.length, 1);
  });

  test('testRecipesContainingIngredientWithMultipleIngredients', () async {
    var recipe = _createRecipe();
    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');

    recipe.ingredientList = [pepper, onion, tomato];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getRecipesContaining(['pEppER', 'tomato', 'ONION']);

    expect(result.length, 1);
  });

  test('testContainsIngredient', () async {
    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');

    var ingredientList = UnmodifiableListView([pepper, onion, tomato]);

    var result = cut.containsIngredient(ingredientList, 'onion');

    expect(result, true);
  });

  test('testContainsNotIngredient', () async {
    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');

    var ingredientList = UnmodifiableListView([pepper, onion, tomato]);

    var result = cut.containsIngredient(ingredientList, 'salt');

    expect(result, false);
  });

  test('testSimilarRecipesReturnsNotSelf', () async {
    MutableRecipe recipe = _createRecipe();

    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');

    recipe.ingredientList = [pepper, onion, tomato];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 0);
  });

  test('testSimilarRecipesThresholdNotReached', () async {
    var recipe = _createRecipe();
    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');
    var salad = _createIngredient('Salad');
    recipe.ingredientList = [pepper, onion, tomato, salad];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    var secondRecipe = _createRecipe();
    secondRecipe.ingredientList = [pepper];

    GetIt.I.get<RecipeManager>().createOrUpdate(secondRecipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 0);
  });

  test('testSimilarRecipesThresholdReached', () async {
    var recipe = _createRecipe();
    var pepper = _createIngredient('Pepper');
    var onion = _createIngredient('Onion');
    var tomato = _createIngredient('Tomato');
    var salad = _createIngredient('Salad');
    recipe.ingredientList = [pepper, onion, tomato, salad];

    GetIt.I.get<RecipeManager>().createOrUpdate(recipe);
    var goatCheese = _createIngredient('Goat Cheese');
    var secondRecipe = _createRecipe();

    secondRecipe.ingredientList = [pepper, salad, goatCheese];

    GetIt.I.get<RecipeManager>().createOrUpdate(secondRecipe);

    var result = await cut.getSimilarRecipes(recipe);

    expect(result.length, 1);
  });
}

MutableRecipe _createRecipe() {
  var recipe = MutableRecipe.empty();
  recipe.id = UniqueKeyIdGenerator().id;
  return recipe;
}
