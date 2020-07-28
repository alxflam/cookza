import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/json/ingredient_note_entity.dart';
import 'package:cookly/model/entities/json/instruction_entity.dart';
import 'package:cookly/model/json/recipe.dart';

class RecipeEntityJson implements RecipeEntity {
  Recipe _recipe;

  RecipeEntityJson.of(Recipe recipe) {
    this._recipe = recipe;
  }

  @override
  String get description => _recipe.shortDescription;

  @override
  DIFFICULTY get difficulty => _recipe.diff;

  @override
  int get duration => _recipe.duration;

  @override
  String get id => _recipe.id;

  @override
  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients =>
      Future.value(UnmodifiableListView(_recipe.ingredients
          .map((e) => IngredientNoteEntityJson.of(e))
          .toList()));

  @override
  Future<UnmodifiableListView<InstructionEntity>> get instructions {
    var result = UnmodifiableListView(
        _recipe.instructions.map((e) => InstructionEntityJson.of(e)).toList());
    return Future.value(result);
  }

  @override
  String get name => _recipe.name;

  @override
  int get rating => _recipe.rating;

  @override
  String get recipeCollectionId => '';

  @override
  int get servings => _recipe.servings;

  @override
  UnmodifiableListView<String> get tags => UnmodifiableListView(_recipe.tags);

  @override
  DateTime get creationDate => _recipe.creationDate;

  @override
  String get creationDateFormatted =>
      kDateFormatter.format(_recipe.creationDate);

  @override
  DateTime get modificationDate => _recipe.modificationDate;

  @override
  String get modificationDateFormatted =>
      kDateFormatter.format(_recipe.modificationDate);

  @override
  String get image => '';

  Uint8List get imageAsBytes {
    return base64.decode(_recipe.serializedImage);
  }

  @override
  bool get hasInMemoryImage => _recipe.serializedImage?.isNotEmpty ?? false;

  @override
  Uint8List get inMemoryImage {
    if (!hasInMemoryImage) {
      throw 'Recipe has no in memory image';
    }
    return imageAsBytes;
  }
}
