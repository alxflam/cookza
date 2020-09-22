import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/recipe_manager_mock.dart';
import '../../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<RecipeManager>(RecipeManagerMock());
  });

  test('Modify mode', () async {
    var recipe = RecipeCreator.createRecipe('Something delicious');
    var cut = RecipeEditModel.modify(recipe);

    expect(cut.isEdit, true);
    expect(cut.targetEntity.id, recipe.id);
    expect(cut.targetEntity.name, recipe.name);
  });

  test('Creation mode', () async {
    var cut = RecipeEditModel.create();

    expect(cut.isEdit, false);
    expect(cut.targetEntity, isNotNull);
  });

  test('Next Step', () async {
    var cut = RecipeEditModel.create();

    expect(cut.currentStep, 0);

    cut.nextStep();
    expect(cut.currentStep, 1);
    cut.nextStep();
    cut.nextStep();
    cut.nextStep();
    expect(cut.currentStep, 4);
  });

  test('Cancel Step', () async {
    var cut = RecipeEditModel.create();
    cut.goToStep(4);
    expect(cut.currentStep, 4);

    cut.previousStep();
    cut.previousStep();
    expect(cut.currentStep, 2);
  });

  test('Go to step', () async {
    var cut = RecipeEditModel.create();

    expect(cut.currentStep, 0);

    cut.goToStep(3);
    expect(cut.currentStep, 3);

    cut.goToStep(10); // not exisiting
    expect(cut.currentStep, 3);
  });

  test('Apply current step', () async {
    var cut = RecipeEditModel.create();
    cut.goToStep(3);
    expect(cut.currentStep, 3);

    var step = RecipeIngredientEditStep();
    cut.applyCurrentStep(step);

    expect(cut.ingredientStepModel, step);
  });
}
