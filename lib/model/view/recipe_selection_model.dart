import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:flutter/cupertino.dart';

enum SELECTION_MODE { EXPORT, IMPORT, REFERENCE_INGREDIENT, ADD_TO_MEAL_PLAN }

class RecipeSelectionModel extends ChangeNotifier {
  List<String> _selected = [];
  List<RecipeViewModel> _recipes;
  List<RecipeViewModel> _filtered = [];

  int _countAllRecipes = 0;
  int _countSelected = 0;
  final SELECTION_MODE _mode;
  SELECTION_MODE get mode => _mode;
  final bool _allowMultiSelection;

  RecipeSelectionModel.forAddMealPlan(this._recipes)
      : this._mode = SELECTION_MODE.ADD_TO_MEAL_PLAN,
        this._allowMultiSelection = false {
    _init();
  }

  RecipeSelectionModel.forReferenceIngredient(this._recipes)
      : this._mode = SELECTION_MODE.REFERENCE_INGREDIENT,
        this._allowMultiSelection = false {
    _init();
  }

  RecipeSelectionModel.forExport(this._recipes)
      : this._mode = SELECTION_MODE.EXPORT,
        this._allowMultiSelection = true {
    _recipes.forEach((item) => _selected.add(item.id));
    _init();
  }

  RecipeSelectionModel.forImport(this._recipes)
      : this._mode = SELECTION_MODE.IMPORT,
        this._allowMultiSelection = true {
    _recipes.forEach((item) => _selected.add(item.id));
    _init();
  }

  void _init() {
    _filtered.addAll(_recipes);
    _countAllRecipes = _recipes.length;
    _countSelected = _selected.length;
  }

  get isMultiSelection => _allowMultiSelection;
  get countSelected => _countSelected;
  get countAll => _countAllRecipes;
  set selected(String id) {
    _selected.add(id);
    notifyListeners();
  }

  List<String> get selectedRecipes => _selected;

  List<Recipe> getSelectedRecipes() => _filtered
      .where((item) => _selected.contains(item.id))
      .map((item) => item.recipe)
      .toList();

  bool isSelected(int index) {
    return _selected.contains(_filtered[index].id);
  }

  String getRecipeName(int index) {
    return _filtered[index].name;
  }

  void switchSelection(int index) {
    var recipe = _filtered[index];

    if (isMultiSelection) {
      if (_selected.contains(recipe.id)) {
        _selected.remove(recipe.id);
      } else {
        _selected.add(recipe.id);
      }
    } else {
      if (_selected.isEmpty || !_selected.contains(recipe.id)) {
        _selected.clear();
        _selected.add(recipe.id);
      } else {
        _selected.remove(recipe.id);
      }
    }

    _countSelected = _selected.length;
    notifyListeners();
  }

  void filter(String value) {
    _filtered.clear();
    if (value.isEmpty) {
      _filtered.addAll(_recipes);
    } else {
      for (var item in _recipes) {
        if (item.name.toLowerCase().contains(value.toLowerCase())) {
          _filtered.add(item);
        } else {
          if (_selected.contains(item.id)) {
            _selected.remove(item.id);
          }
        }
      }
    }

    _countAllRecipes = _filtered.length;
    notifyListeners();
  }
}
