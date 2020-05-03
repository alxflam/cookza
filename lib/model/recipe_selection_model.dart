import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/recipe_view_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:flutter/cupertino.dart';

enum DATA_EXCHANGE_DIRECTION { EXPORT, IMPORT }

class RecipeSelectionModel extends ChangeNotifier {
  List<String> _selected = [];
  List<RecipeViewModel> recipes;
  int _countAllRecipes;
  int _countSelected;
  final DATA_EXCHANGE_DIRECTION mode;

  RecipeSelectionModel({this.mode, this.recipes}) {
    recipes.forEach((item) => _selected.add(item.id));
    _countAllRecipes = recipes.length;
    _countSelected = _selected.length;
  }

  get countSelected => _countSelected;
  get countAll => _countAllRecipes;
  set selected(String id) {
    _selected.add(id);
    notifyListeners();
  }

  get selected => _selected;

  List<Recipe> getSelectedRecipes() => recipes
      .where((item) => _selected.contains(item.id))
      .map((item) => item.recipe)
      .toList();

  bool isSelected(int index) {
    return _selected.contains(recipes[index].id);
  }

  String getRecipeName(int index) {
    return recipes[index].name;
  }

  void switchSelection(int index) {
    var recipe = recipes[index];
    if (_selected.contains(recipe.id)) {
      _selected.remove(recipe.id);
    } else {
      _selected.add(recipe.id);
    }
    _countSelected = _selected.length;
    notifyListeners();
  }
}
