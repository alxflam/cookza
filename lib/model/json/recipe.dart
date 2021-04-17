import 'dart:convert';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable(includeIfNull: false)
class Recipe {
  factory Recipe.fromJson(Map<String, dynamic> json, {String? id}) {
    var instance = _$RecipeFromJson(json);
    instance.documentID = id;
    return instance;
  }

  static Future<Recipe> applyFrom(RecipeEntity entity) async {
    var instance = Recipe(
        name: entity.name,
        shortDescription: entity.description,
        recipeCollection: entity.recipeCollectionId,
        creationDate: entity.creationDate,
        modificationDate: entity.modificationDate,
        duration: entity.duration,
        rating: entity.rating ?? 0,
        servings: entity.servings,
        diff: entity.difficulty,
        tags: entity.tags,
        id: '',
        instructions: [],
        ingredients: []);

    var ins = await entity.instructions;
    instance.instructions = ins.map((e) => e.text).toList();
    var ing = await entity.ingredients;
    instance.ingredients =
        ing.map((e) => IngredientNote.fromEntity(e)).toList();
    if (entity.image != null && entity.image!.isNotEmpty) {
      var imageFile = await sl.get<ImageManager>().getRecipeImageFile(entity);
      if (imageFile != null) {
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64.encode(imageBytes);
        instance.serializedImage = base64Image;
      }
    }
    return instance;
  }

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  @JsonKey(ignore: true)
  String? documentID;
  @JsonKey()
  String id;
  @JsonKey()
  String recipeCollection;

  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime creationDate;
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime modificationDate;

  @JsonKey()
  String name;
  @JsonKey(defaultValue: '')
  String? shortDescription;
  @JsonKey()
  int duration;
  @JsonKey(defaultValue: 0)
  int rating;
  @JsonKey(defaultValue: 1)
  int servings;
  @JsonKey()
  String? serializedImage;

  @JsonKey(defaultValue: DIFFICULTY.MEDIUM)
  DIFFICULTY diff;
  @JsonKey()
  List<String> tags;
  @JsonKey(toJson: kListToJson)
  List<IngredientNote> ingredients;
  @JsonKey()
  List<String> instructions;

  Recipe(
      {required this.id,
      required this.recipeCollection,
      required this.name,
      required this.shortDescription,
      required this.creationDate,
      required this.modificationDate,
      required this.duration,
      required this.diff,
      required this.tags,
      required this.ingredients,
      required this.instructions,
      required this.rating,
      required this.servings,
      this.serializedImage}) {
    if (this.servings == 0) {
      this.servings = 1;
    }
  }
}
