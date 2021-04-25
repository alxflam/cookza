import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/firebase/recipe_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_recipe.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseRecipe {
  factory FirebaseRecipe.fromJson(Map<String, dynamic> json, {String? id}) {
    var instance = _$FirebaseRecipeFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseRecipeToJson(this);

  @JsonKey(ignore: true)
  String? documentID;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationDate;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp modificationDate;
  @JsonKey()
  String? ingredientsID;
  @JsonKey()
  String? instructionsID;

  @JsonKey()
  String name;
  @JsonKey(defaultValue: '')
  String? description;
  @JsonKey()
  int duration;
  @JsonKey(defaultValue: 1)
  int servings;
  @JsonKey()
  String? image;
  @JsonKey()
  String recipeGroupID;

  @JsonKey(defaultValue: DIFFICULTY.MEDIUM)
  DIFFICULTY difficulty;
  @JsonKey()
  List<String> tags;

  FirebaseRecipe({
    this.documentID,
    this.ingredientsID,
    this.instructionsID,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.modificationDate,
    required this.duration,
    required this.difficulty,
    required this.tags,
    required this.servings,
    required this.image,
    required this.recipeGroupID,
  }) {
    if (this.servings == 0) {
      this.servings = 1;
    }
  }

  factory FirebaseRecipe.from(RecipeEntity recipe) {
    var instance = FirebaseRecipe(
      name: recipe.name,
      description: recipe.description,
      creationDate: Timestamp.fromDate(recipe.creationDate),
      modificationDate: Timestamp.fromDate(recipe.modificationDate),
      duration: recipe.duration,
      difficulty: recipe.difficulty,
      tags: recipe.tags,
      servings: recipe.servings,
      image: recipe.image,
      documentID: recipe.id,
      recipeGroupID: recipe.recipeCollectionId,
    );

    if (recipe is RecipeEntityFirebase) {
      instance.ingredientsID = recipe.ingredientsID;
      instance.instructionsID = recipe.instructionsID;
    }

    return instance;
  }
}
