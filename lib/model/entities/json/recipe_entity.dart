import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/ingredient_note_entity.dart';
import 'package:cookza/model/entities/json/instruction_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/json/recipe.dart';

class RecipeEntityJson implements RecipeEntity {
  final Recipe _recipe;

  RecipeEntityJson.of(this._recipe);

  @override
  String? get description => _recipe.shortDescription;

  @override
  DIFFICULTY get difficulty => _recipe.diff;

  @override
  int get duration => _recipe.duration;

  @override
  String get id => _recipe.id;

  @override
  Future<UnmodifiableListView<InstructionEntity>> get instructions {
    var result = UnmodifiableListView(
        _recipe.instructions.map((e) => InstructionEntityJson.of(e)).toList());
    return Future.value(result);
  }

  @override
  String get name => _recipe.name;

  @override
  String get recipeCollectionId => _recipe.recipeCollection;

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

  Uint8List? get imageAsBytes {
    if (hasInMemoryImage) {
      return base64.decode(_recipe.serializedImage!);
    }
    return null;
  }

  @override
  bool get hasInMemoryImage => _recipe.serializedImage?.isNotEmpty ?? false;

  @override
  Uint8List get inMemoryImage {
    if (!hasInMemoryImage) {
      throw 'Recipe has no in memory image';
    }
    return imageAsBytes!;
  }

  @override
  Future<UnmodifiableListView<IngredientGroupEntity>> get ingredientGroups {
    final result = _recipe.ingredientGroups.map(
      (e) => MutableIngredientGroup.forValues(
        1,
        e.name,
        e.ingredients
            .map(
                (e) => MutableIngredientNote.of(IngredientNoteEntityJson.of(e)))
            .toList(),
      ),
    );
    return Future.value(UnmodifiableListView(result));
  }
}
