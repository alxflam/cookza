import 'dart:io';

import 'package:cookly/model/json/ingredient.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/services/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/cupertino.dart';

abstract class RecipeEditStep extends ChangeNotifier {
  vaildate();
  void applyTo(Recipe recipe);
  void applyFrom(Recipe recipe);
}

class RecipeOverviewEditStep extends RecipeEditStep {
  String name = '';
  String description = '';
  int _duration = 10;
  DIFFICULTY _difficulty = DIFFICULTY.EASY;
  DateTime creationDate = DateTime.now();
  final DateTime modificationDate = DateTime.now();

  int get duration => _duration;
  DIFFICULTY get difficulty => _difficulty;

  set duration(int duration) {
    _duration = duration;
    notifyListeners();
  }

  set difficulty(DIFFICULTY diff) {
    _difficulty = diff;
    notifyListeners();
  }

  @override
  void applyTo(Recipe recipe) {
    recipe.name = this.name;
    recipe.shortDescription = this.description;
    recipe.diff = this.difficulty;
    recipe.duration = this.duration;
    recipe.modificationDate = this.modificationDate;
  }

  @override
  void applyFrom(Recipe recipe) {
    this.name = recipe.name;
    this.description = recipe.shortDescription;
    this.difficulty = recipe.diff;
    this.duration = recipe.duration;
    this.creationDate = recipe.creationDate;
  }

  @override
  vaildate() {
    if (name.isEmpty) {
      throw 'Assign a Recipe name';
    }
    if (description.isEmpty) {
      throw 'Assign a Recipe description';
    }
    if (duration <= 0) {
      throw 'Assign a Recipe duration';
    }
    if (difficulty == null) {
      throw 'Assign a Recipe difficulty';
    }
  }
}

class RecipeImageEditStep extends RecipeEditStep {
  File _image;

  File get image => _image;

  set image(File image) {
    _image = image;
    notifyListeners();
  }

  @override
  void applyTo(Recipe recipe) {
    // actually there's nothing to do here
    // the image is applied / saved separately
  }

  @override
  void applyFrom(Recipe recipe) {
    var currentImage = sl.get<DataStore>().appProfile.getRecipeImage(recipe.id);
    currentImage.then((value) {
      if (value != null) {
        this._image = value.file;
      }
    });
  }

  @override
  bool vaildate() {
    // nothing to validate
  }
}

class RecipeTagEditStep extends RecipeEditStep {
  List<String> _tags = [];

  get isVegan => tags.contains('vegan');
  get isVegetarian => tags.contains('vegetarian');
  get containsMeat => tags.contains('meat');
  get containsFish => tags.contains('fish');
  List<String> get tags => _tags;

  void setVegan(bool isSet) {
    if (isSet) {
      tags.add('vegan');
      tags.add('vegetarian');
      tags.remove('meat');
      tags.remove('fish');
    } else {
      tags.remove('vegan');
    }
    notifyListeners();
  }

  void setVegetarian(bool isSet) {
    if (isSet) {
      tags.add('vegetarian');
      tags.remove('meat');
      tags.remove('fish');
    } else {
      tags.remove('vegetarian');
    }
    notifyListeners();
  }

  void setContainsMeat(bool isSet) {
    if (isSet) {
      tags.add('meat');
      tags.remove('vegetarian');
      tags.remove('vegan');
    } else {
      tags.remove('meat');
    }
    notifyListeners();
  }

  void setContainsFish(bool isSet) {
    if (isSet) {
      tags.add('fish');
      tags.remove('vegetarian');
      tags.remove('vegan');
    } else {
      tags.remove('fish');
    }
    notifyListeners();
  }

  @override
  void applyFrom(Recipe recipe) {
    this._tags = recipe.tags;
  }

  @override
  void applyTo(Recipe recipe) {
    recipe.tags = this._tags;
  }

  @override
  vaildate() {
    // allow adding no tags at all
  }
}

class RecipeIngredientEditStep extends RecipeEditStep {
  int _servings = 1;
  List<IngredientNote> _ingredients = [];

  int get servings => _servings;

  set servings(int value) {
    _servings = value;
    notifyListeners();
  }

  void addEmptyIngredient() {
    _addEmptyIngredient();
    notifyListeners();
  }

  void _addEmptyIngredient() {
    this._ingredients.add(
          IngredientNote(amount: 0, ingredient: Ingredient(name: '')),
        );
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

  void setAmount(int index, double amount) {
    this._ingredients[index].amount = amount;
  }

  void setScale(int index, String scale) {
    this._ingredients[index].unitOfMeasure = scale;
    notifyListeners();
  }

  void setIngredient(int index, String ingredient) {
    this._ingredients[index].ingredient.name = ingredient;
  }

  void removeIngredient(int index) {
    this._ingredients.removeAt(index);
    notifyListeners();
  }

  List<IngredientNote> get ingredients {
    return this._ingredients;
  }

  @override
  void applyFrom(Recipe recipe) {
    this._ingredients = recipe.ingredients;
    this._servings = recipe.servings;
  }

  @override
  void applyTo(Recipe recipe) {
    recipe.ingredients = this._ingredients;
    recipe.servings = this._servings;
  }

  @override
  vaildate() {
    if (_ingredients.isEmpty) {
      throw 'There are no ingredients assigned to the recipe';
    }

    if (_servings <= 0) {
      throw 'Assign a valid servings size';
    }
  }
}

class RecipeInstructionEditStep extends RecipeEditStep {
  List<String> _instructions = [];

  List<String> get instructions => _instructions;

  void setInstruction(String text, int index) {
    while (_instructions.length <= index) {
      _instructions.add('');
    }
    _instructions[index] = text;
  }

  String getInstruction(int index) {
    if (index > _instructions.length) {
      return '';
    }
    return _instructions[index];
  }

  void addEmptyInstruction() {
    addInstruction('');
    notifyListeners();
  }

  void addInstruction(String text) {
    this._instructions.add(text == null ? '' : text);
  }

  void removeInstruction(int i) {
    this._instructions.removeAt(i);
    notifyListeners();
  }

  void clearInstructions() {
    this._instructions.clear();
  }

  @override
  void applyFrom(Recipe recipe) {
    this._instructions = recipe.instructions;
  }

  @override
  void applyTo(Recipe recipe) {
    recipe.instructions = this._instructions;
  }

  @override
  vaildate() {
    // there are instructions and there's no empty instruction

    if (_instructions.isEmpty ||
        _instructions.where((f) => f.isEmpty).length > 0) {
      throw 'There are no instructions assigned to the recipe';
    }
  }
}
