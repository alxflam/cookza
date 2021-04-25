import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/recipe_creator.dart';

List<RecipeViewModel> createRecipes() {
  List<RecipeViewModel> result = [];
  var recipe = RecipeCreator.createRecipe('My Recipe');
  recipe.id = 'A';
  recipe.description = 'My description';
  recipe.duration = 65;
  recipe.difficulty = DIFFICULTY.HARD;
  recipe.addTag('vegetarian');
  result.add(RecipeViewModel.of(recipe));

  recipe = RecipeCreator.createRecipe('Another Recipe');
  recipe.id = 'B';
  recipe.description = 'Some Desc';
  recipe.duration = 30;
  recipe.difficulty = DIFFICULTY.EASY;
  recipe.addTag('meat');
  result.add(RecipeViewModel.of(recipe));

  return result;
}

void main() {
  test('Model for Import', () async {
    var cut = RecipeSelectionModel.forImport(createRecipes());
    expect(cut.mode, SELECTION_MODE.IMPORT);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);
  });

  test('Model for Export', () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.mode, SELECTION_MODE.EXPORT);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);
  });

  test('Model for Export PDF', () async {
    var cut = RecipeSelectionModel.forExportPDF(createRecipes());
    expect(cut.mode, SELECTION_MODE.EXPORT_PDF);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);
  });

  test('Model for Reference Ingredient', () async {
    var cut = RecipeSelectionModel.forReferenceIngredient(createRecipes(), []);
    expect(cut.mode, SELECTION_MODE.REFERENCE_INGREDIENT);
    expect(cut.isMultiSelection, false);
    expect(cut.countSelected, 0);
    expect(cut.countAll, 2);
  });

  test('Model for Reference Ingredient - exclude recipe', () async {
    var cut =
        RecipeSelectionModel.forReferenceIngredient(createRecipes(), ['A']);
    expect(cut.mode, SELECTION_MODE.REFERENCE_INGREDIENT);
    expect(cut.isMultiSelection, false);
    expect(cut.countSelected, 0);
    expect(cut.countAll, 1);
  });

  test('Model for add MealPlan', () async {
    var cut = RecipeSelectionModel.forAddMealPlan(createRecipes());
    expect(cut.mode, SELECTION_MODE.ADD_TO_MEAL_PLAN);
    expect(cut.isMultiSelection, false);
    expect(cut.countSelected, 0);
    expect(cut.countAll, 2);
  });

  test('Set Selected  multi select', () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.mode, SELECTION_MODE.EXPORT);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);

    /// deselect all
    cut.deselectAll();
    expect(cut.countSelected, 0);

    /// select all
    cut.selectAll();
    expect(cut.countSelected, 2);

    /// deselect one
    cut.switchSelection(1);
    expect(cut.isSelected(1), false);
    expect(cut.countSelected, 1);

    /// and select it again
    cut.switchSelection(1);
    expect(cut.isSelected(1), true);
    expect(cut.countSelected, 2);
  });

  test('Filter recipes by text', () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.mode, SELECTION_MODE.EXPORT);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);

    /// deselect all
    cut.deselectAll();
    expect(cut.countSelected, 0);
    expect(cut.countAll, 2);

    /// filter by non exisiting
    cut.filter('WHATEVER');
    expect(cut.countAll, 0);

    /// filter by existing - contained in both recipe names
    /// case insensitive filtering
    cut.filter('recipe');
    expect(cut.countAll, 2);
  });

  test('Filtering does not reset previous selection of filtered recipes',
      () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.mode, SELECTION_MODE.EXPORT);
    expect(cut.isMultiSelection, true);
    expect(cut.countSelected, 2);
    expect(cut.countAll, 2);

    /// deselect all
    cut.deselectAll();
    expect(cut.countSelected, 0);
    expect(cut.countAll, 2);

    /// select first recipe
    cut.switchSelection(0);
    expect(cut.isSelected(0), true);

    /// filter by exisiting - matchers 'Another Recipe'
    /// still one recipe is selected
    cut.filter('nother');
    expect(cut.countAll, 1);
    expect(cut.countSelected, 1);

    // then select it
    cut.switchSelection(0);
    expect(cut.isSelected(0), true);
    expect(cut.countSelected, 2);

    // then remove the filter
    cut.filter('');
    expect(cut.countAll, 2);
    expect(cut.countSelected, 2);
  });

  test('Get recipes', () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.getRecipeName(0), 'My Recipe');
    expect(cut.getRecipeName(1), 'Another Recipe');
  });

  test('Get selected recipes', () async {
    var cut = RecipeSelectionModel.forExport(createRecipes());
    expect(cut.selectedRecipeEntities.length, 2);
    expect(cut.selectedRecipeViewModels.length, 2);
    expect(cut.selectedRecipes.length, 2);
    expect(cut.getSelectedRecipes().length, 2);
  });

  test('Switch selection single select', () async {
    var cut = RecipeSelectionModel.forReferenceIngredient(createRecipes(), []);

    /// select a recipe
    cut.switchSelection(0);
    expect(cut.countSelected, 1);
    expect(cut.isSelected(0), true);

    /// selecting another one deselct the previously selected
    cut.switchSelection(1);
    expect(cut.countSelected, 1);
    expect(cut.isSelected(0), false);
    expect(cut.isSelected(1), true);
  });
}
