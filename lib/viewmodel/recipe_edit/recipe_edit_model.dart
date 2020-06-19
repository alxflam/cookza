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

  Future<void> save() async {
    _validate();
    for (var model in _stepModels) {
      model.applyTo(_targetRecipe);
    }

    // retrieve the enxt document id if a new recipe is being created
    var recipeId = _targetRecipe.id;
    if (this._mode == MODE.CREATE) {
      recipeId = sl
          .get<RecipeManager>()
          .getNextRecipeDocumentId(_targetRecipe.recipeCollectionId);
    }

    if (imageStepModel.imageChanged) {
      // upload the image for the given recipe
      var path = sl.get<ImageManager>().getRecipeImagePath(recipeId);
      if (imageStepModel.image == null) {
        // delete the image if exists
        sl.get<ImageManager>().deleteRecipeImage(recipeId);
      } else {
        // upload the image
        // TODO: only upload if the image changed - the model needs to keep that information!
        sl
            .get<ImageManager>()
            .uploadRecipeImage(recipeId, imageStepModel.image);
      }
      // set the image path on the recipe
      _targetRecipe.image = path;
    }

    // then save the recipe
    await sl.get<RecipeManager>().createOrUpdate(_targetRecipe);

    // AppProfile profile = sl.get<DataStore>().appProfile;
    // profile.addOrUpdateRecipe(_targetRecipe);

    // // todo let the profile handle that and only delegate here to the profile!
    // await profile.updateImage(file: imageStepModel.image, id: _targetRecipe.id);
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
