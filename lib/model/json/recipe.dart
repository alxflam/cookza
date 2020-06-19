import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable(includeIfNull: false)
class Recipe {
  factory Recipe.fromJson(Map<String, dynamic> json, {String id}) {
    var instance = _$RecipeFromJson(json);
    instance.documentID = id;
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

  @JsonKey(defaultValue: DIFFICULTY.MEDIUM)
  DIFFICULTY diff;
  @JsonKey(nullable: false)
  List<String> tags;
  @JsonKey(toJson: kListToJson)
  List<IngredientNote> ingredients;
  @JsonKey(nullable: false)
  List<String> instructions;

  Recipe.editCopyFrom(Recipe recipe) {
    // todo handle keep same id in edit mode
    this.id = recipe.id;
    this.recipeCollection = recipe.recipeCollection;
    this.name = recipe.name;
    this.shortDescription = recipe.shortDescription;
    this.duration = recipe.duration;
    this.diff = recipe.diff;
    this.tags = recipe.tags;
    this.ingredients = recipe.ingredients.toList();
    this.instructions = recipe.instructions.toList();
    this.creationDate = recipe.creationDate;
    this.modificationDate = DateTime.now();
    this.servings = recipe.servings;
  }

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
      this.servings}) {
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
