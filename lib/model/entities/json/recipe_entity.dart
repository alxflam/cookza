import 'dart:collection';

import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/json/recipe.dart';

class RecipeEntityJson implements RecipeEntity {
  Recipe _recipe;

  RecipeEntityJson.of(Recipe recipe) {
    this._recipe = recipe;
  }

  @override
  // TODO: implement description
  String get description => throw UnimplementedError();

  @override
  // TODO: implement difficulty
  DIFFICULTY get difficulty => throw UnimplementedError();

  @override
  // TODO: implement duration
  int get duration => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement ingredients
  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients =>
      throw UnimplementedError();

  @override
  // TODO: implement instructions
  Future<UnmodifiableListView<InstructionEntity>> get instructions =>
      throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement rating
  int get rating => throw UnimplementedError();

  @override
  // TODO: implement recipeCollectionId
  String get recipeCollectionId => throw UnimplementedError();

  @override
  // TODO: implement servings
  int get servings => throw UnimplementedError();

  @override
  // TODO: implement tags
  UnmodifiableListView<String> get tags => throw UnimplementedError();

  @override
  // TODO: implement creationDate
  DateTime get creationDate => throw UnimplementedError();

  @override
  // TODO: implement creationDateFormatted
  String get creationDateFormatted => throw UnimplementedError();

  @override
  // TODO: implement modificationDate
  DateTime get modificationDate => throw UnimplementedError();

  @override
  // TODO: implement modificationDateFormatted
  String get modificationDateFormatted => throw UnimplementedError();

  @override
  // TODO: implement image
  String get image => throw UnimplementedError();
}
