import 'dart:collection';
import 'dart:typed_data';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_group_entity.dart';
import 'package:cookza/model/entities/firebase/instruction_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';

class RecipeEntityFirebase implements RecipeEntity {
  final FirebaseRecipe _recipe;

  List<IngredientGroupEntityFirebase> _ingredientGroups = [];

  List<InstructionEntityFirebase> _instructions = [];

  RecipeEntityFirebase.of(this._recipe);

  String? get instructionsID => _recipe.instructionsID;

  String? get ingredientsID => _recipe.ingredientsID;

  @override
  String? get description => this._recipe.description;

  @override
  DIFFICULTY get difficulty => this._recipe.difficulty;

  @override
  int get duration => this._recipe.duration;

  @override
  String? get id => this._recipe.documentID;

  @override
  Future<UnmodifiableListView<InstructionEntity>> get instructions async {
    if (this._instructions.isEmpty) {
      this._instructions = await sl.get<FirebaseProvider>().recipeInstructions(
          this._recipe.recipeGroupID, this._recipe.documentID!);
    }
    return Future.value(UnmodifiableListView(this._instructions));
  }

  @override
  String get name => this._recipe.name;

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
  String? get image => this._recipe.image;

  @override
  bool get hasInMemoryImage => false;

  @override
  Uint8List? get inMemoryImage => null;

  @override
  Future<UnmodifiableListView<IngredientGroupEntity>>
      get ingredientGroups async {
    if (this._ingredientGroups.isEmpty) {
      this._ingredientGroups = await sl
          .get<FirebaseProvider>()
          .recipeIngredientGroups(
              this._recipe.recipeGroupID, this._recipe.documentID!);
    }
    return Future.value(UnmodifiableListView(this._ingredientGroups));
  }
}
