import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_ingredient.g.dart';

dynamic _toJson(Ingredient ingredient) {
  return ingredient.toJson();
}

@JsonSerializable(includeIfNull: false)
class FirebaseIngredient {
  @JsonKey(toJson: _toJson)
  Ingredient ingredient;
  @JsonKey(defaultValue: '')
  String unitOfMeasure;
  @JsonKey()
  double amount;

  FirebaseIngredient(
      {required this.ingredient,
      required this.unitOfMeasure,
      required this.amount});

  FirebaseIngredient.create()
      : this.ingredient = Ingredient(name: ''),
        this.amount = 0,
        this.unitOfMeasure = '';

  factory FirebaseIngredient.fromJson(Map<String, dynamic> json) {
    var instance = _$FirebaseIngredientFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseIngredientToJson(this);

  static Future<List<FirebaseIngredient>> from(RecipeEntity recipe) async {
    List<FirebaseIngredient> result = [];
    var ing = await recipe.ingredients;
    for (var item in ing) {
      result.add(FirebaseIngredient(
          ingredient: Ingredient(
              name: item.ingredient.name,
              recipeReference: item.ingredient.recipeReference),
          amount: item.amount,
          unitOfMeasure: item.unitOfMeasure));
    }
    return result;
  }
}

@JsonSerializable(includeIfNull: false)
class FirebaseIngredientDocument {
  @JsonKey(ignore: true)
  String? documentID;
  @JsonKey()
  String recipeID;
  @JsonKey(toJson: kListToJson)
  List<FirebaseIngredient> ingredients;

  FirebaseIngredientDocument(
      {this.documentID, required this.recipeID, required this.ingredients});

  factory FirebaseIngredientDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseIngredientDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseIngredientDocumentToJson(this);

  static FirebaseIngredientDocument from(
      List<FirebaseIngredient> ingredients, String recipeID) {
    return FirebaseIngredientDocument(
        ingredients: ingredients, recipeID: recipeID);
  }
}
