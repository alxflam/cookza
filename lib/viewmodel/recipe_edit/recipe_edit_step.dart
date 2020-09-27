import 'dart:io';

import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/ingredient_entity.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_instruction.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/recipe/image_manager.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'recipe_ingredient_model.dart';

abstract class RecipeEditStep extends ChangeNotifier {
  validate();
  void applyTo(MutableRecipe recipe);
  void applyFrom(RecipeEntity recipe);
  bool get hasOCR => false;
}

class RecipeOverviewEditStep extends RecipeEditStep {
  String name = '';
  String description = '';
  int _duration = 10;
  DIFFICULTY _difficulty = DIFFICULTY.EASY;
  DateTime creationDate = DateTime.now();
  final DateTime modificationDate = DateTime.now();
  RecipeCollectionEntity collection;

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
  void applyTo(MutableRecipe recipe) {
    recipe.name = this.name;
    recipe.description = this.description;
    recipe.difficulty = this.difficulty;
    recipe.duration = this.duration;
    recipe.modificationDate = this.modificationDate;
    recipe.recipeCollectionId = this.collection.id;
  }

  @override
  void applyFrom(RecipeEntity recipe) async {
    this.name = recipe.name;
    this.description = recipe.description;
    this.difficulty = recipe.difficulty;
    this.duration = recipe.duration;
    this.creationDate = recipe.creationDate;
    var collection =
        await sl.get<RecipeManager>().collectionByID(recipe.recipeCollectionId);
    this.collection = collection;
  }

  @override
  validate() {
    if (name.isEmpty) {
      throw translate(Keys.Ui_Assignrecipename);
    }
    if (duration <= 0) {
      throw translate(Keys.Ui_Assignrecipeduration);
    }
    if (difficulty == null) {
      throw translate(Keys.Ui_Assignrecipedifficulty);
    }
    if (this.collection == null) {
      throw translate(Keys.Ui_Assignrecipegroup);
    }
  }

  @override
  bool get hasOCR => true;
}

class RecipeImageEditStep extends RecipeEditStep {
  File _image;
  dynamic _initialState;

  File get image => _image;

  set image(File image) {
    _image = image;
    notifyListeners();
  }

  bool get imageChanged {
    return this._initialState != this._image;
  }

  @override
  void applyTo(MutableRecipe recipe) {
    // actually there's nothing to do here if the user chose an image
    // the image is applied / saved separately as it first needs to be uploaded before we can determine the image path
    if (this._image == null) {
      recipe.image = null;
    }
  }

  @override
  void applyFrom(RecipeEntity recipe) async {
    var currentImage = recipe.image;

    if (currentImage != null && currentImage.isNotEmpty) {
      this._initialState = currentImage;
      this._image = await sl.get<ImageManager>().getRecipeImageFile(recipe);
    }
  }

  @override
  validate() {
    // nothing to validate - it's fine if the user chose no image
  }
}

class RecipeTagEditStep extends RecipeEditStep {
  Set<String> _tags = {};

  get isVegan => tags.contains('vegan');
  get isVegetarian => tags.contains('vegetarian');
  get containsMeat => tags.contains('meat');
  get containsFish => tags.contains('fish');
  Set<String> get tags => _tags;

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
      tags.remove('vegan');
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
  void applyFrom(RecipeEntity recipe) {
    this._tags = Set.of(recipe.tags);
  }

  @override
  void applyTo(MutableRecipe recipe) {
    recipe.tags = this._tags.toList();
  }

  @override
  validate() {
    // allow adding no tags at all
  }
}

class RecipeIngredientEditStep extends RecipeEditStep {
  int _servings = 1;
  List<MutableIngredientNote> _ingredients = [];

  int get servings => _servings;

  set servings(int value) {
    _servings = value;
    notifyListeners();
  }

  void addNewIngredient(RecipeIngredientModel item) {
    this._ingredients.add(MutableIngredientNote.of(item.toIngredientNote()));
    notifyListeners();
  }

  void setAmount(int index, double amount) {
    this._ingredients[index].amount = amount;
  }

  void setScale(int index, String scale) {
    this._ingredients[index].unitOfMeasure = scale;
    notifyListeners();
  }

  void setIngredient(int index, IngredientEntity ingredient) {
    this._ingredients[index].ingredient = MutableIngredient.of(ingredient);
  }

  void removeIngredient(int index) {
    this._ingredients.removeAt(index);
    notifyListeners();
  }

  List<RecipeIngredientModel> get ingredients {
    return this._ingredients.map((i) => RecipeIngredientModel.of(i)).toList();
  }

  @override
  void applyFrom(RecipeEntity recipe) {
    assert(recipe != null);
    assert(recipe.ingredients != null);
    assert(recipe.servings != null);

    recipe.ingredients.then((value) {
      var ing = value.map((e) => MutableIngredientNote.of(e)).toList();
      this._ingredients = ing;
    });

    this._servings = recipe.servings;
  }

  @override
  void applyTo(MutableRecipe recipe) {
    recipe.ingredientList = this._ingredients;
    recipe.servings = this._servings;
  }

  @override
  validate() {
    if (_ingredients.isEmpty) {
      throw translate(Keys.Ui_Assigningredients);
    }

    if (_servings <= 0) {
      throw translate(Keys.Ui_Assignservings);
    }
  }

  @override
  bool get hasOCR => true;
}

class RecipeInstructionEditStep extends RecipeEditStep {
  List<MutableInstruction> _instructions = [];

  List<InstructionEntity> get instructions => _instructions;

  RecipeInstructionEditStep() {
    _instructions.add(MutableInstruction.empty());
  }

  void setInstruction(String text, int index) {
    while (_instructions.length <= index) {
      _instructions.add(MutableInstruction.empty());
    }
    _instructions[index].text = text;
  }

  InstructionEntity getInstruction(int index) {
    if (index > _instructions.length) {
      return null;
    }
    return _instructions[index];
  }

  void addEmptyInstruction() {
    addInstruction('');
    notifyListeners();
  }

  void addInstruction(String text) {
    this._instructions.add(text == null
        ? MutableInstruction.empty()
        : MutableInstruction.withValues(text: text));
  }

  void removeInstruction(int i) {
    this._instructions.removeAt(i);
    notifyListeners();
  }

  @override
  void applyFrom(RecipeEntity recipe) {
    recipe.instructions.then((value) {
      var instructions = value.map((e) => MutableInstruction.of(e)).toList();
      this._instructions = instructions;
    });
  }

  @override
  void applyTo(MutableRecipe recipe) {
    for (var i = 0; i < this._instructions.length; i++) {
      this._instructions[i].step = i + 1;
    }
    recipe.instructionList = this._instructions;
  }

  @override
  validate() {
    // there are instructions and there's no empty instruction
    if (_instructions.isEmpty) {
      throw translate(Keys.Ui_Assigninstructions);
    }
    if (_instructions.where((f) => f.text == null || f.text.isEmpty).length >
        0) {
      throw translate(Keys.Ui_Assignemptyinstructions);
    }
  }

  @override
  bool get hasOCR => true;
}
