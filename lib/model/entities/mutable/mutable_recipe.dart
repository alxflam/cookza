import 'dart:collection';
import 'dart:typed_data';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';

class MutableRecipe implements RecipeEntity {
  final DateTime _creationDate;
  DateTime _modificationDate;
  String? _description = '';
  String _name = '';
  DIFFICULTY _difficulty;
  int _duration = 20;
  String? _id;
  String? _recipeCollectionId;
  @deprecated
  List<IngredientNoteEntity>? _ingredients;
  List<IngredientGroupEntity> _ingredientGroups = [];
  List<InstructionEntity>? _instructions;
  Future<List<IngredientNoteEntity>>? _origIngredients;
  Future<List<InstructionEntity>>? _origInstructions;
  Set<String> _tags = {};
  int _servings = 2;
  String? _image;
  Uint8List? _inMemoryImage;

  MutableRecipe.empty()
      : this._creationDate = DateTime.now(),
        this._modificationDate = DateTime.now(),
        this._difficulty = DIFFICULTY.EASY,
        this._ingredients = [],
        this._ingredientGroups = [],
        this._instructions = [],
        this._tags = <String>{},
        this._servings = 2;

  MutableRecipe.of(RecipeEntity entity)
      : this._creationDate = entity.creationDate,
        this._modificationDate = entity.modificationDate,
        this._description = entity.description,
        this._name = entity.name,
        this._difficulty = entity.difficulty,
        this._duration = entity.duration,
        this._id = entity.id,
        this._recipeCollectionId = entity.recipeCollectionId {
    if (entity.hasInMemoryImage) {
      this._inMemoryImage = entity.inMemoryImage;
    }

    _origInstructions = entity.instructions;

    entity.ingredientGroups.then((value) {
      this._ingredientGroups = [...value];
    });

    entity.instructions.then((value) {
      var list = value.map((e) => MutableInstruction.of(e)).toList();
      this._instructions = list;
    });

    this._tags = Set.of(entity.tags);
    this._servings = entity.servings;
    this._image = entity.image;
  }

  @override
  String get creationDateFormatted => kDateFormatter.format(this._creationDate);

  @override
  DateTime get creationDate => this._creationDate;

  @override
  String? get description => this._description;

  set id(String? value) => this._id = value;

  set description(String? value) {
    this._description = value;
  }

  @override
  DIFFICULTY get difficulty => this._difficulty;

  set difficulty(DIFFICULTY value) {
    this._difficulty = value;
  }

  @override
  int get duration => this._duration;

  set duration(int value) {
    this._duration = value;
  }

  @override
  String? get id => this._id;

  @override
  Future<UnmodifiableListView<IngredientNoteEntity>> get ingredients async {
    var original = await this._origIngredients;
    return Future.value(UnmodifiableListView(this._ingredients ?? original!));
  }

  set ingredientList(List<IngredientNoteEntity> value) {
    this._ingredients = value;
  }

  set ingredientGroupList(List<IngredientGroupEntity> value) {
    this._ingredientGroups = value;
  }

  @override
  Future<UnmodifiableListView<InstructionEntity>> get instructions async {
    var original = await this._origInstructions;
    return Future.value(UnmodifiableListView(this._instructions ?? original!));
  }

  set instructionList(List<InstructionEntity> value) {
    this._instructions = value;
  }

  @override
  String get modificationDateFormatted =>
      kDateFormatter.format(this._modificationDate);

  @override
  DateTime get modificationDate => this._modificationDate;

  set modificationDate(DateTime value) {
    this._modificationDate = value;
  }

  @override
  String get name => this._name;

  set name(String value) {
    this._name = value;
  }

  @override
  String get recipeCollectionId => this._recipeCollectionId!;

  set recipeCollectionId(String value) {
    this._recipeCollectionId = value;
  }

  @override
  int get servings => this._servings;

  set servings(int value) {
    this._servings = value;
  }

  @override
  UnmodifiableListView<String> get tags => UnmodifiableListView(this._tags);

  void addTag(String value) {
    if (!this._tags.contains(value.toLowerCase())) {
      this._tags.add(value.toLowerCase());
    }
  }

  void removeTage(String value) {
    this._tags.remove(value);
  }

  set tags(List<String> value) {
    this._tags = Set.of(value);
  }

  @override
  String? get image => _image;

  set image(String? value) {
    this._image = value;
  }

  @override
  bool get hasInMemoryImage => this._inMemoryImage != null;

  @override
  Uint8List get inMemoryImage {
    if (!hasInMemoryImage) {
      throw 'Recipe has no in memory image';
    }
    return this._inMemoryImage!;
  }

  @override
  Future<UnmodifiableListView<IngredientGroupEntity>> get ingredientGroups {
    return Future.value(UnmodifiableListView(this._ingredientGroups));
  }
}
