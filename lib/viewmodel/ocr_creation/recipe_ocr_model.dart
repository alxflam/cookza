import 'package:cookly/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/material.dart';

class RecipeOCRModel extends ChangeNotifier {
  RecipeOCRModel.create();

  List<RecipeOCRStep> _stepModels = [
    RecipeImageOCRStep(),
    RecipeIngredientOCRStep(),
    RecipeInstructionOCRStep(),
  ];

  int _currentStep = 0;

  int get countSteps => _stepModels.length;
  int get currentStep => _currentStep;

  RecipeImageOCRStep get overviewStepModel => _stepModels[0];
  RecipeIngredientOCRStep get ingredientStepModel => _stepModels[1];
  RecipeInstructionOCRStep get instructionStepModel => _stepModels[2];

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

  RecipeEditModel toRecipeEditModel() {
    return RecipeEditModel.fromSteps(overviewStepModel.model,
        ingredientStepModel.model, instructionStepModel.model);
  }
}
