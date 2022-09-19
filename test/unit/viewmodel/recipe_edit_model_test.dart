import 'package:cookza/model/entities/json/recipe_collection_entity.dart';
import 'package:cookza/model/json/recipe_collection.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/recipe_creator.dart';

void main() {
  final mock = MockRecipeManager();

  setUpAll(() async {
    GetIt.I.registerSingleton<RecipeManager>(mock);
    GetIt.I.registerSingleton<NavigatorService>(MockNavigatorService());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    await GetIt.I.allReady();
  });

  test('Modify mode', () async {
    final collection = RecipeCollectionEntityJson.of(
        RecipeCollection(id: 'test', name: 'test'));
    when(mock.collectionByID(any)).thenAnswer((_) => Future.value(collection));
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
