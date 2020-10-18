import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/cupertino.dart';

enum SELECTION_MODE {
  EXPORT,
  IMPORT,
  REFERENCE_INGREDIENT,
  ADD_TO_MEAL_PLAN,
  EXPORT_PDF
}

class RecipeSelectionModel extends ChangeNotifier {
  final List<String> _selected = [];

  /// excluded, non-selectable recipes - e.g. for reference ingredients:
  /// no self reference should be possible
  List<String> _excludes = [];
  final List<RecipeViewModel> _recipes;
  final List<RecipeViewModel> _filtered = [];

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

  RecipeSelectionModel.forReferenceIngredient(this._recipes, this._excludes)
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

  RecipeSelectionModel.forExportPDF(this._recipes)
      : this._mode = SELECTION_MODE.EXPORT_PDF,
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
    /// remove excluded recipes
    this._recipes.removeWhere((e) => this._excludes.contains(e.id));
    _filtered.addAll(_recipes);
    _countAllRecipes = _recipes.length;
    _countSelected = _selected.length;
  }

  bool get isMultiSelection => _allowMultiSelection;
  int get countSelected => _countSelected;
  int get countAll => _countAllRecipes;

  List<String> get selectedRecipes => _selected;

  List<RecipeViewModel> get selectedRecipeViewModels =>
      _recipes.where((element) => _selected.contains(element.id)).toList();

  List<RecipeEntity> get selectedRecipeEntities {
    return _recipes
        .where((e) => _selected.contains(e.id))
        .map((e) => e.recipe)
        .toList();
  }

  List<RecipeEntity> getSelectedRecipes() => _filtered
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
        }
      }
    }

    _countAllRecipes = _filtered.length;
    notifyListeners();
  }

  void selectAll() {
    for (var item in _filtered) {
      if (!_selected.contains(item.id)) {
        _selected.add(item.id);
      }
    }
    _countSelected = _selected.length;
    notifyListeners();
  }

  void deselectAll() {
    for (var item in _filtered) {
      _selected.remove(item.id);
    }
    _countSelected = _selected.length;
    notifyListeners();
  }
}
