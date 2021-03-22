import 'package:cookza/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:flutter/material.dart';

class MealPlanItemDialogModel with ChangeNotifier {
  int _servings;
  String _name;
  final bool _isNote;
  bool _deleted = false;
  bool _changed = false;
  MealPlanRecipeModel? _model;

  MealPlanItemDialogModel.forItem(MealPlanRecipeModel model)
      : this._model = model,
        this._servings = model.servings,
        this._name = model.name,
        this._isNote = model.isNote;

  MealPlanItemDialogModel.createNote()
      : this._servings = 0,
        this._name = '',
        this._isNote = true;

  bool get isNote => _isNote;
  String get name => _name;
  int get servings => _servings;
  bool get isDeleted => _deleted;
  bool get hasChanged => _changed;

  set name(String value) {
    this._name = value;
  }

  set servings(int value) {
    if (value > 0 && value < 20) {
      this._servings = value;
      notifyListeners();
    }
  }

  void applyChanges() {
    this._changed = true;

    // creation of a note: there's not yet a underlying model, therefore return
    if (this.isNote && this._model == null) {
      return;
    }

    if (isNote) {
      this._model?.name = this._name;
    } else {
      this._model?.servings = this._servings;
    }
  }

  void setDeleted(bool value) {
    this._deleted = value;
  }
}
