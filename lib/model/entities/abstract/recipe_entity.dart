import 'dart:collection';
import 'dart:typed_data';

import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';

enum DIFFICULTY { EASY, MEDIUM, HARD }

abstract class RecipeEntity {
  String? get id;
  String get recipeCollectionId;

  String get name;
  String? get description;
  int get duration;
  int get servings;
  String get creationDateFormatted;
  String get modificationDateFormatted;
  DateTime get creationDate;
  DateTime get modificationDate;

  String? get image;
  bool get hasInMemoryImage;
  Uint8List? get inMemoryImage;

  DIFFICULTY get difficulty;

  /// returns all ingredients
  @deprecated
  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients;

  /// returns the grouped ingredients
  Future<UnmodifiableListView<IngredientGroupEntity>> get ingredientGroups;

  /// returns all instructions
  Future<UnmodifiableListView<InstructionEntity>> get instructions;

  /// returns all tags
  UnmodifiableListView<String> get tags;
}
