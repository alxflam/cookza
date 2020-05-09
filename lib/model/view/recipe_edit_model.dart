import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/view/recipe_edit_step.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

enum MODE { CREATE, MODIFY }

class RecipeEditModel extends ChangeNotifier {
  RecipeEditModel.create() {
    _mode = MODE.CREATE;
    _targetRecipe = Recipe();
  }

  RecipeEditModel.modify(Recipe recipe) {
    _mode = MODE.MODIFY;
    _targetRecipe = recipe;
    for (var model in _stepModels) {
      model.applyFrom(recipe);
    }
  }

  Recipe _targetRecipe;
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
      step.vaildate();
    }
  }

  Future<void> save() async {
    _validate();
    for (var model in _stepModels) {
      model.applyTo(_targetRecipe);
    }

    AppProfile profile = sl.get<DataStore>().appProfile;
    profile.addOrUpdateRecipe(_targetRecipe);

    // todo let the profile handle that and only delegate here to the profile!
    if (imageStepModel.image != null) {
      await profile.addImage(file: imageStepModel.image, id: _targetRecipe.id);
    }
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
}
