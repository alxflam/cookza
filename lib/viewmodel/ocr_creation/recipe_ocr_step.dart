import 'dart:io';

import 'package:cookly/services/image_parser.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';

abstract class RecipeOCRStep<T extends RecipeEditStep> with ChangeNotifier {
  File _image;

  bool _isPending = false;

  T get model;

  set image(File image) {
    this._image = image;
    this._isPending = true;
    this.analyse();
    notifyListeners();
  }

  File get image => this._image;

  bool get isPending => this._isPending;

  bool get isValid;

  void analyse();
}

class RecipeImageOCRStep extends RecipeOCRStep<RecipeOverviewEditStep> {
  RecipeOverviewEditStep _model = RecipeOverviewEditStep();

  @override
  bool get isValid {
    return _model.name.isNotEmpty;
  }

  @override
  void analyse() async {
    this._model =
        await sl.get<ImageTextExtractor>().processOverviewImage(this._image);
    this._isPending = false;
    notifyListeners();
  }

  @override
  RecipeOverviewEditStep get model => this._model;
}

class RecipeIngredientOCRStep extends RecipeOCRStep<RecipeIngredientEditStep> {
  RecipeIngredientEditStep _model = RecipeIngredientEditStep();

  @override
  bool get isValid {
    return this._model.ingredients.isNotEmpty;
  }

  @override
  void analyse() async {
    this._model =
        await sl.get<ImageTextExtractor>().processIngredientsImage(this._image);
    this._isPending = false;
    notifyListeners();
  }

  @override
  RecipeIngredientEditStep get model => this._model;
}

class RecipeInstructionOCRStep
    extends RecipeOCRStep<RecipeInstructionEditStep> {
  RecipeInstructionEditStep _model = RecipeInstructionEditStep();

  @override
  bool get isValid {
    return this
        ._model
        .instructions
        .where((e) => e.text.isNotEmpty)
        .toList()
        .isNotEmpty;
  }

  @override
  void analyse() async {
    this._model = await sl
        .get<ImageTextExtractor>()
        .processInstructionsImage(this._image);
    this._isPending = false;
    notifyListeners();
  }

  @override
  RecipeInstructionEditStep get model => this._model;
}
