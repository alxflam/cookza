import 'dart:collection';
import 'dart:typed_data';

import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';

enum DIFFICULTY { EASY, MEDIUM, HARD }

abstract class RecipeEntity {
  String get id;
  String get recipeCollectionId;

  String get name;
  String get description;
  int get duration;
  int get servings;
  int get rating;
  String get creationDateFormatted;
  String get modificationDateFormatted;
  DateTime get creationDate;
  DateTime get modificationDate;

  String get image;
  bool get hasInMemoryImage;
  Uint8List get inMemoryImage;

  DIFFICULTY get difficulty;

  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients;
  Future<UnmodifiableListView<InstructionEntity>> get instructions;
  UnmodifiableListView<String> get tags;
}
