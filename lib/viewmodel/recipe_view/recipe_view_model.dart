import 'dart:collection';

import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';

class RecipeViewModel extends ChangeNotifier {
  RecipeEntity _recipe;
  late int _servings;
  int _rating = 0;
  @deprecated
  final List<InstructionEntity> _instructions = [];
  final List<MutableIngredientGroup> _ingredientGroups = [];

  RecipeViewModel.of(this._recipe) {
    _copyValues();
  }

  void _copyValues() {
    this._instructions.clear();

    this._servings = this._recipe.servings;

    this._recipe.ingredientGroups.then((value) {
      for (var group in value) {
        this._ingredientGroups.add(MutableIngredientGroup.forValues(
            group.index,
            group.name,
            group.ingredients
                .map((e) => MutableIngredientNote.of(e))
                .toList()));
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
  String get id => _recipe.id!;
  String get name => _recipe.name;
  String? get description => _recipe.description;
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

  List<String> get tags => _recipe.tags;

  Future<void> setRating(int rating) async {
    if (rating < 6 && rating > -1) {
      await sl.get<RecipeManager>().updateRating(this._recipe, rating);
      this._rating = rating;
      notifyListeners();
    }
  }

  List<IngredientGroupEntity> get ingredientGroups {
    return UnmodifiableListView(_ingredientGroups);
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

    _recipe.ingredientGroups.then((groups) {
      for (var i = 0; i < groups.length; i++) {
        final group = groups[i];
        for (var j = 0; j < group.ingredients.length; j++) {
          var baseAmount = group.ingredients[j].amount;
          _ingredientGroups[i].ingredients[j].amount =
              (baseAmount ?? 1) * ratio;
        }
      }

      notifyListeners();
    });
  }
}
