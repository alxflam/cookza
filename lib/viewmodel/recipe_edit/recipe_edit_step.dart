import 'dart:io';

import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';

import 'recipe_ingredient_model.dart';

abstract class RecipeEditStep extends ChangeNotifier {
  void validate(BuildContext context);
  void applyTo(MutableRecipe recipe);
  void applyFrom(RecipeEntity recipe);
  bool get hasOCR => false;
}

class RecipeOverviewEditStep extends RecipeEditStep {
  String name = '';
  String? description = '';
  // TODO PRIO2 default duration preference
  int _duration = 10;
  // TODO PRIO2 default difficulty preference
  DIFFICULTY _difficulty = DIFFICULTY.EASY;
  DateTime creationDate = DateTime.now();
  final DateTime modificationDate = DateTime.now();
  RecipeCollectionEntity? collection;

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
    recipe.recipeCollectionId = this.collection?.id ?? '';
  }

  @override
  void applyFrom(RecipeEntity recipe) async {
    this.name = recipe.name;
    this.description = recipe.description;
    this.difficulty = recipe.difficulty;
    this.duration = recipe.duration;
    this.creationDate = recipe.creationDate;
    if (recipe.recipeCollectionId.isNotEmpty) {
      var collection = await sl
          .get<RecipeManager>()
          .collectionByID(recipe.recipeCollectionId);
      this.collection = collection;
    }
  }

  @override
  void validate(BuildContext context) {
    if (name.isEmpty) {
      throw AppLocalizations.of(context).assignRecipeName;
    }
    if (duration <= 0) {
      throw AppLocalizations.of(context).assignRecipeDuration;
    }
    if (this.collection == null) {
      throw AppLocalizations.of(context).assignRecipeGroup;
    }
  }

  @override
  bool get hasOCR => true;
}

class RecipeImageEditStep extends RecipeEditStep {
  File? _image;
  dynamic _initialState;

  File? get image => _image;

  set image(File? image) {
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
  void validate(BuildContext context) {
    // nothing to validate - it's fine if the user chose no image
  }
}

class RecipeTagEditStep extends RecipeEditStep {
  Set<String> _tags = {};

  bool get isVegan => tags.contains('vegan');
  bool get isVegetarian => tags.contains('vegetarian');
  bool get containsMeat => tags.contains('meat');
  bool get containsFish => tags.contains('fish');
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
      tags.remove('vegan');
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
  void validate(BuildContext context) {
    // allow adding no tags at all
  }
}

class RecipeIngredientEditStep extends RecipeEditStep {
  /// initial servings
  int _servings =
      sl.get<SharedPreferencesProvider>().getNewRecipeServingsSize();

  List<IngredientGroupEntity> _groups = [];

  int get servings => _servings;

  List<IngredientGroupEntity> get groups => this._groups;

  MutableIngredientGroup addGroup(String name) {
    MutableIngredientGroup group = _createAndAddGroup(name);
    notifyListeners();
    return group;
  }

  MutableIngredientGroup _createAndAddGroup(String name) {
    final group =
        MutableIngredientGroup.forValues(this.groups.length, name, []);
    this._groups.add(group);
    return group;
  }

  void removeGroup(IngredientGroupEntity group) {
    this._groups.remove(group);
    notifyListeners();
  }

  set servings(int value) {
    _servings = value;
    notifyListeners();
  }

  void addNewIngredient(
      RecipeIngredientModel item, IngredientGroupEntity group) {
    if (!this.groups.contains(group)) {
      this.groups.add(group);
    }
    group.ingredients.add(MutableIngredientNote.of(item.toIngredientNote()));
    notifyListeners();
  }

  void setAmount(int index, double? amount, IngredientGroupEntity group) {
    final note = group.ingredients[index] as MutableIngredientNote;
    note.amount = amount;
  }

  void setScale(int index, String? scale, IngredientGroupEntity group) {
    final note = group.ingredients[index] as MutableIngredientNote;
    note.unitOfMeasure = scale;
    notifyListeners();
  }

  void changeGroup(
      int index, IngredientGroupEntity current, IngredientGroupEntity target) {
    final note = current.ingredients.removeAt(index);
    IngredientGroupEntity targetGroup;
    if (!this._groups.contains(target)) {
      targetGroup = _createAndAddGroup(target.name);
    } else {
      targetGroup = this._groups[this._groups.indexOf(target)];
    }
    targetGroup.ingredients.add(note);

    notifyListeners();
  }

  void setIngredient(
      int index, IngredientEntity ingredient, IngredientGroupEntity group) {
    final note = group.ingredients[index] as MutableIngredientNote;
    note.ingredient = MutableIngredient.of(ingredient);
  }

  void removeIngredient(int index, IngredientGroupEntity group) {
    group.ingredients.removeAt(index);
    notifyListeners();
  }

  @override
  void applyFrom(RecipeEntity recipe) {
// TODO await these setters...apply needs to be async!

    recipe.ingredientGroups.then((value) {
      this._groups = [...value];
    });

    this._servings = recipe.servings;
  }

  @override
  void applyTo(MutableRecipe recipe) {
    recipe.servings = this._servings;
    // remove empty groups - there may be empty groups due to group assignment changes
    this._groups.removeWhere((e) => e.ingredients.isEmpty);
    recipe.ingredientGroupList = this._groups;
  }

  @override
  void validate(BuildContext context) {
    if (_groups.isEmpty) {
      throw AppLocalizations.of(context).assignIngredients;
    }

    if (_servings <= 0) {
      throw AppLocalizations.of(context).assignServings;
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
      throw 'Index does not exist';
    }
    return _instructions[index];
  }

  void addEmptyInstruction() {
    this._instructions.add(MutableInstruction.empty());
    notifyListeners();
  }

  void addInstruction(String text) {
    this._instructions.add(MutableInstruction.withValues(text: text));
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
  void validate(BuildContext context) {
    // there are instructions and there's no empty instruction
    if (_instructions.isEmpty) {
      throw AppLocalizations.of(context).assignInstructions;
    }
    if (_instructions.where((f) => f.text.isEmpty).isNotEmpty) {
      throw AppLocalizations.of(context).assignEmptyInstructions;
    }
  }

  @override
  bool get hasOCR => true;
}
