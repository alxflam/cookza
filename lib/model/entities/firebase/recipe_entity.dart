import 'dart:collection';
import 'dart:typed_data';

import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookly/model/entities/firebase/instruction_entity.dart';
import 'package:cookly/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/flutter/service_locator.dart';

class RecipeEntityFirebase implements RecipeEntity {
  FirebaseRecipe _recipe;

  List<IngredientNoteEntityFirebase> _ingredients = [];

  List<InstructionEntityFirebase> _instructions = [];

  RecipeEntityFirebase.of(FirebaseRecipe recipe) {
    this._recipe = recipe;
  }

  String get instructionsID => _recipe.instructionsID;

  String get ingredientsID => _recipe.ingredientsID;

  @override
  String get description => this._recipe.description;

  @override
  DIFFICULTY get difficulty => this._recipe.difficulty;

  @override
  int get duration => this._recipe.duration;

  @override
  String get id => this._recipe.documentID;

  @override
  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients async {
    if (this._ingredients.isEmpty) {
      this._ingredients = await sl.get<FirebaseProvider>().recipeIngredients(
          this._recipe.recipeGroupID, this._recipe.documentID);
    }
    return Future.value(UnmodifiableListView(this._ingredients));
  }

  @override
  Future<UnmodifiableListView<InstructionEntity>> get instructions async {
    if (this._instructions.isEmpty) {
      this._instructions = await sl.get<FirebaseProvider>().recipeInstructions(
          this._recipe.recipeGroupID, this._recipe.documentID);
    }
    return Future.value(UnmodifiableListView(this._instructions));
  }

  @override
  String get name => this._recipe.name;

  @override
  int get rating => this._recipe.rating;

  @override
  String get recipeCollectionId => this._recipe.recipeGroupID;

  @override
  int get servings => this._recipe.servings;

  @override
  UnmodifiableListView<String> get tags =>
      UnmodifiableListView(this._recipe.tags);

  @override
  String get creationDateFormatted => kDateFormatter.format(creationDate);

  @override
  String get modificationDateFormatted =>
      kDateFormatter.format(modificationDate);

  @override
  DateTime get creationDate => this._recipe.creationDate.toDate();

  @override
  DateTime get modificationDate => this._recipe.modificationDate.toDate();

  @override
  String get image => this._recipe.image;

  @override
  bool get hasInMemoryImage => false;

  @override
  Uint8List get inMemoryImage => null;
}
