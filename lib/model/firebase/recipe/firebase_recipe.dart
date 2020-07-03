import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/firebase/recipe_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_recipe.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseRecipe {
  factory FirebaseRecipe.fromJson(Map<String, dynamic> json, {String id}) {
    var instance = _$FirebaseRecipeFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseRecipeToJson(this);

  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationDate;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp modificationDate;
  @JsonKey(nullable: false)
  String ingredientsID;
  @JsonKey(nullable: false)
  String instructionsID;

  @JsonKey(nullable: false)
  String name;
  @JsonKey(defaultValue: '')
  String description;
  @JsonKey(nullable: false)
  int duration;
  @JsonKey(defaultValue: 0)
  int rating;
  @JsonKey(defaultValue: 1)
  int servings;
  @JsonKey(nullable: true)
  String image;
  @JsonKey(nullable: false)
  String recipeGroupID;

  @JsonKey(defaultValue: DIFFICULTY.MEDIUM)
  DIFFICULTY difficulty;
  @JsonKey(nullable: false)
  List<String> tags;

  FirebaseRecipe({
    this.documentID,
    this.ingredientsID,
    this.instructionsID,
    this.name,
    this.description,
    this.creationDate,
    this.modificationDate,
    this.duration,
    this.difficulty,
    this.tags,
    this.rating,
    this.servings,
    this.image,
    this.recipeGroupID,
  }) {
    // initalize values
    if (this.tags == null) {
      this.tags = [];
    }
    if (this.rating == null) {
      this.rating = 0;
    }
    if (this.creationDate == null) {
      this.creationDate = Timestamp.now();
    }
    if (this.modificationDate == null) {
      this.modificationDate = Timestamp.now();
    }
    if (this.servings == null || this.servings == 0) {
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
      rating: recipe.rating,
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
