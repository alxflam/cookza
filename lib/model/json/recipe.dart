import 'dart:convert';

import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/services/util/id_gen.dart';
import 'package:cookly/services/recipe/image_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable(includeIfNull: false)
class Recipe {
  factory Recipe.fromJson(Map<String, dynamic> json, {String id}) {
    var instance = _$RecipeFromJson(json);
    instance.documentID = id;
    return instance;
  }

  static Future<Recipe> applyFrom(RecipeEntity entity) async {
    var instance = Recipe();
    instance.name = entity.name;
    instance.shortDescription = entity.description;
    instance.recipeCollection = entity.recipeCollectionId;
    instance.creationDate = entity.creationDate;
    instance.modificationDate = entity.modificationDate;
    instance.duration = entity.duration;
    instance.rating = entity.rating;
    instance.servings = entity.servings;
    instance.diff = entity.difficulty;
    instance.tags = entity.tags;
    var ins = await entity.instructions;
    instance.instructions = ins.map((e) => e.text).toList();
    var ing = await entity.ingredients;
    instance.ingredients =
        ing.map((e) => IngredientNote.fromEntity(e)).toList();
    if (entity.image != null && entity.image.isNotEmpty) {
      var imageFile = await sl.get<ImageManager>().getRecipeImageFile(entity);
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      instance.serializedImage = base64Image;
    }
    return instance;
  }

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(nullable: false)
  String id;
  @JsonKey(nullable: false)
  String recipeCollection;

  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime creationDate;
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime modificationDate;

  @JsonKey(nullable: false)
  String name;
  @JsonKey(defaultValue: '')
  String shortDescription;
  @JsonKey(nullable: false)
  int duration;
  @JsonKey(defaultValue: 0)
  int rating;
  @JsonKey(defaultValue: 1)
  int servings;
  @JsonKey(nullable: true)
  String serializedImage;

  @JsonKey(defaultValue: DIFFICULTY.MEDIUM)
  DIFFICULTY diff;
  @JsonKey(nullable: false)
  List<String> tags;
  @JsonKey(toJson: kListToJson)
  List<IngredientNote> ingredients;
  @JsonKey(nullable: false)
  List<String> instructions;

  Recipe(
      {this.id,
      this.recipeCollection,
      this.name,
      this.shortDescription,
      this.creationDate,
      this.modificationDate,
      this.duration,
      this.diff,
      this.tags,
      this.ingredients,
      this.instructions,
      this.rating,
      this.servings,
      this.serializedImage}) {
    // initalize values
    if (this.id == null) {
      this.id = sl.get<IdGenerator>().id;
    }
    if (this.ingredients == null) {
      this.ingredients = [];
    }
    if (this.tags == null) {
      this.tags = [];
    }
    if (this.rating == null) {
      this.rating = 0;
    }
    if (this.instructions == null) {
      this.instructions = [];
    }
    if (this.creationDate == null) {
      this.creationDate = DateTime.now();
    }
    if (this.modificationDate == null) {
      this.modificationDate = DateTime.now();
    }
    if (this.servings == null || this.servings == 0) {
      this.servings = 1;
    }
  }
}
