import 'package:cookly/constants.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/view/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';

class RecipeViewModel extends ChangeNotifier {
  Recipe _recipe;
  int _servings;
  List<IngredientNote> _ingredients = [];

  RecipeViewModel.of(this._recipe) {
    this._servings = this._recipe.servings;
    for (var note in this._recipe.ingredients) {
      this._ingredients.add(IngredientNote.from(note));
    }
  }

  int get servings => _servings;
  String get id => _recipe.id;
  String get name => _recipe.name;
  String get description => _recipe.shortDescription;
  int get duration => _recipe.duration;
  int get rating => _recipe.rating;
  String get creationDate => kDateFormatter.format(_recipe.creationDate);
  String get modificationDate =>
      kDateFormatter.format(_recipe.modificationDate);
  List<String> get instructions => _recipe.instructions;
  Recipe get recipe => _recipe;

  DIFFICULTY get difficulty {
    return this._recipe.diff;
  }

  get isVegan => _recipe.tags.contains('vegan');
  get isVegetarian => _recipe.tags.contains('vegetarian');
  get containsMeat => _recipe.tags.contains('meat');
  get containsFish => _recipe.tags.contains('fish');
  List<String> get tags => _recipe.tags;

  void setRating(int rating) {
    if (rating < 6 && rating > -1) {
      this._recipe.rating = rating;
      notifyListeners();
    }
  }

  List<RecipeIngredientModel> get ingredients {
    return this._ingredients.map((e) => RecipeIngredientModel.of(e)).toList();
  }

  String getScaleAt(int index) {
    return this._ingredients[index].unitOfMeasure;
  }

  double getAmountAt(int index) {
    return this._ingredients[index].amount;
  }

  String getIngredientAt(int index) {
    return this._ingredients[index].ingredient.name;
  }

  String getInstruction(int index) {
    if (index > _recipe.instructions.length) {
      return '';
    }
    return _recipe.instructions[index];
  }

  void decreaseServings() {
    this._servings = this._servings <= 1 ? this._servings : this._servings - 1;
    _updateIngredients(_servings);
  }

  void increaseServings() {
    this._servings = this._servings > 20 ? this._servings : this._servings + 1;
    _updateIngredients(_servings);
  }

  void _updateIngredients(int servings) {
    var baseServings = _recipe.servings;
    var ratio = servings / baseServings;
    print('ratio for ing is $ratio');

    for (var i = 0; i < _recipe.ingredients.length; i++) {
      var baseAmount = _recipe.ingredients[i].amount;
      _ingredients[i].amount = baseAmount * ratio;
      print('calculated amount is ${_ingredients[i].amount}');
    }

    notifyListeners();
  }
}
