import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';

enum MODE { CREATE, MODIFY }

class RecipeEditModel extends ChangeNotifier {
  RecipeEditModel.create() {
    _mode = MODE.CREATE;
    _targetRecipe = MutableRecipe.empty();
  }

  RecipeEditModel.modify(RecipeEntity recipe) {
    _mode = MODE.MODIFY;
    _targetRecipe = MutableRecipe.of(recipe);
    for (var model in _stepModels) {
      model.applyFrom(recipe);
    }
  }

  RecipeEditModel.fromSteps(
      RecipeOverviewEditStep overviewStep,
      RecipeIngredientEditStep ingredientStep,
      RecipeInstructionEditStep instructionStep) {
    _mode = MODE.CREATE;
    _targetRecipe = MutableRecipe.empty();
    if (overviewStep != null) {
      _stepModels[0] = overviewStep;
    }
    if (ingredientStep != null) {
      _stepModels[3] = ingredientStep;
    }
    if (instructionStep != null) {
      _stepModels[4] = instructionStep;
    }
  }

  MutableRecipe _targetRecipe;
  MODE _mode;
  List<RecipeEditStep> _stepModels = [
    RecipeOverviewEditStep(),
    RecipeImageEditStep(),
    RecipeTagEditStep(),
    RecipeIngredientEditStep(),
    RecipeInstructionEditStep(),
  ];

  int _currentStep = 0;

  String get recipeId => _targetRecipe.id;
  int get countSteps => _stepModels.length;
  bool get isEdit => _mode == MODE.MODIFY;
  bool get isCreate => _mode == MODE.CREATE;
  int get currentStep => _currentStep;

  RecipeOverviewEditStep get overviewStepModel => _stepModels[0];
  RecipeImageEditStep get imageStepModel => _stepModels[1];
  RecipeTagEditStep get tagStepModel => _stepModels[2];
  RecipeIngredientEditStep get ingredientStepModel => _stepModels[3];
  RecipeInstructionEditStep get instructionStepModel => _stepModels[4];

  void _validate() {
    for (var step in _stepModels) {
      step.validate();
    }
  }

  Future<String> save() async {
    _validate();
    print('validation succeeded');

    for (var model in _stepModels) {
      model.applyTo(_targetRecipe);
    }
    print('model prepared for save');

    // retrieve the next document id if a new recipe is being created with an image
    // then we need to know the recipe id in advance to upload the image
    if (this._mode == MODE.CREATE && imageStepModel.image != null) {
      _targetRecipe.id = sl
          .get<RecipeManager>()
          .getNextRecipeDocumentId(_targetRecipe.recipeCollectionId);
      print('getNextRecipeDocumentId returned: ' + _targetRecipe.id);
    }

    if (imageStepModel.imageChanged) {
      // upload the image for the given recipe
      var path = sl.get<ImageManager>().getRecipeImagePath(_targetRecipe.id);
      if (imageStepModel.image == null) {
        // delete the image if exists
        sl.get<ImageManager>().deleteRecipeImage(_targetRecipe);
      } else {
        // upload the image
        await sl
            .get<ImageManager>()
            .uploadRecipeImage(_targetRecipe.id, imageStepModel.image);
        // set the image path on the recipe
        _targetRecipe.image = 'true';
      }
    }

    // then save the recipe
    return await sl.get<RecipeManager>().createOrUpdate(_targetRecipe);
  }

  void nextStep() {
    _currentStep++;
    print('model step increased to $_currentStep');
    notifyListeners();
  }

  void previousStep() {
    _currentStep--;
    print('model step decreased to $_currentStep');
    notifyListeners();
  }

  void goToStep(int step) {
    if (step < this.countSteps && step >= 0) {
      _currentStep = step;
    }
    notifyListeners();
  }
}
