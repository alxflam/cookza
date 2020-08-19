import 'dart:collection';

import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/json/instruction_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';

class RecipeViewModel extends ChangeNotifier {
  RecipeEntity _recipe;
  int _servings;
  int _rating;
  List<MutableIngredientNote> _ingredients = [];
  List<InstructionEntity> _instructions = [];

  // TODO: make it capable of in memory images like import json
  RecipeViewModel.of(this._recipe) {
    _copyValues();
  }

  void _copyValues() {
    this._ingredients.clear();
    this._instructions.clear();

    this._servings = this._recipe.servings;
    this._rating = _recipe.rating;

    this._recipe.ingredients.then((value) {
      for (var note in value) {
        this._ingredients.add(MutableIngredientNote.of(note));
      }
    });

    this._recipe.instructions.then((value) {
      for (var instruction in value) {
        this._instructions.add(instruction);
      }
    });
  }

  void refreshFrom(RecipeEntity entity) {
    this._recipe = entity;
    _copyValues();
    notifyListeners();
  }

  int get servings => _servings;
  String get id => _recipe.id;
  String get name => _recipe.name;
  String get description => _recipe.description;
  int get duration => _recipe.duration;
  int get rating => this._rating;
  String get creationDate => _recipe.creationDateFormatted;
  String get modificationDate => _recipe.modificationDateFormatted;
  UnmodifiableListView<InstructionEntity> get instructions =>
      UnmodifiableListView(this._instructions);
  RecipeEntity get recipe => _recipe;

  DIFFICULTY get difficulty {
    return this._recipe.difficulty;
  }

  get isVegan => _recipe.tags.contains('vegan');
  get isVegetarian => _recipe.tags.contains('vegetarian');
  get containsMeat => _recipe.tags.contains('meat');
  get containsFish => _recipe.tags.contains('fish');
  List<String> get tags => _recipe.tags;

  void setRating(int rating) async {
    if (rating < 6 && rating > -1) {
      sl.get<RecipeManager>().updateRating(this._recipe, rating).then((value) {
        this._rating = rating;
        notifyListeners();
      });
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

  InstructionEntity getInstruction(int index) {
    if (index > this._instructions.length) {
      return InstructionEntityJson.of('');
    }
    return this._instructions[index];
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

    // TODO necessary async?
    _recipe.ingredients.then((value) {
      for (var i = 0; i < value.length; i++) {
        var baseAmount = value[i].amount;
        _ingredients[i].amount = baseAmount * ratio;
        print('calculated amount is ${_ingredients[i].amount}');
      }

      notifyListeners();
    });
  }
}
