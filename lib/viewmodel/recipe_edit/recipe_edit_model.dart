import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';

enum MODE { CREATE, MODIFY }

class RecipeEditModel extends ChangeNotifier {
  MutableRecipe _targetRecipe;
  MODE _mode;
  final List<RecipeEditStep> _stepModels = [
    RecipeOverviewEditStep(),
    RecipeImageEditStep(),
    RecipeTagEditStep(),
    RecipeIngredientEditStep(),
    RecipeInstructionEditStep(),
  ];

  int _currentStep = 0;

  RecipeEntity get targetEntity => _targetRecipe;
  int get countSteps => _stepModels.length;
  bool get isEdit => _mode == MODE.MODIFY;
  bool get isCreate => _mode == MODE.CREATE;
  int get currentStep => _currentStep;

  RecipeOverviewEditStep get overviewStepModel =>
      _stepModels[0] as RecipeOverviewEditStep;
  RecipeImageEditStep get imageStepModel =>
      _stepModels[1] as RecipeImageEditStep;
  RecipeTagEditStep get tagStepModel => _stepModels[2] as RecipeTagEditStep;
  RecipeIngredientEditStep get ingredientStepModel =>
      _stepModels[3] as RecipeIngredientEditStep;
  RecipeInstructionEditStep get instructionStepModel =>
      _stepModels[4] as RecipeInstructionEditStep;

  RecipeEditModel.create({RecipeCollectionEntity? collection})
      : _mode = MODE.CREATE,
        _targetRecipe = MutableRecipe.empty() {
    if (collection != null) {
      overviewStepModel.collection = collection;
    }
  }

  RecipeEditModel.modify(RecipeEntity recipe)
      : _mode = MODE.MODIFY,
        _targetRecipe = MutableRecipe.of(recipe) {
    for (var model in _stepModels) {
      model.applyFrom(recipe);
    }
  }

  void _validate(BuildContext context) {
    for (var step in _stepModels) {
      step.validate(context);
    }
  }

  Future<String> save(BuildContext context) async {
    _validate(context);
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
      print('getNextRecipeDocumentId returned: ' + _targetRecipe.id!);
    }

    if (imageStepModel.imageChanged) {
      // upload the image for the given recipe
      if (imageStepModel.image == null) {
        // delete the image if exists
        await sl.get<ImageManager>().deleteRecipeImage(_targetRecipe);
      } else {
        // upload the image
        await sl
            .get<ImageManager>()
            .uploadRecipeImage(_targetRecipe.id!, imageStepModel.image!);
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

  bool hasCurrentStepOCR() {
    return _stepModels[currentStep].hasOCR;
  }

  void applyCurrentStep(RecipeEditStep value) {
    _stepModels[this.currentStep] = value;
    notifyListeners();
  }
}
