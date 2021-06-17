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
  String? unitOfMeasure;
  @JsonKey()
  double? amount;

  FirebaseIngredient({
    required this.ingredient,
    this.amount,
    this.unitOfMeasure,
  });

  FirebaseIngredient.create() : this.ingredient = Ingredient(name: '');

  factory FirebaseIngredient.fromJson(Map<String, dynamic> json) {
    var instance = _$FirebaseIngredientFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseIngredientToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FirebaseIngredientGroup {
  @JsonKey(toJson: kListToJson)
  List<FirebaseIngredient> ingredients;
  @JsonKey()
  String name;

  FirebaseIngredientGroup({required this.name, required this.ingredients});

  factory FirebaseIngredientGroup.fromJson(Map<String, dynamic> json) {
    return _$FirebaseIngredientGroupFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FirebaseIngredientGroupToJson(this);

  static Future<List<FirebaseIngredientGroup>> from(RecipeEntity recipe) async {
    List<FirebaseIngredientGroup> result = [];
    var groups = await recipe.ingredientGroups;

    for (var group in groups) {
      if (group.ingredients.isEmpty) {
        // skip empty groups
        continue;
      }
      result.add(
        FirebaseIngredientGroup(
          name: group.name,
          ingredients: group.ingredients
              .map(
                (e) => FirebaseIngredient(
                    ingredient: Ingredient(
                        name: e.ingredient.name,
                        recipeReference: e.ingredient.recipeReference),
                    amount: e.amount,
                    unitOfMeasure: e.unitOfMeasure),
              )
              .toList(),
        ),
      );
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
  // TODO remove once all recipes are migrated to groups
  @deprecated
  @JsonKey(toJson: kListToJson)
  List<FirebaseIngredient>? ingredients;
  @JsonKey(toJson: kListToJson)
  List<FirebaseIngredientGroup>? groups;

  FirebaseIngredientDocument(
      {this.documentID,
      required this.recipeID,
      required this.ingredients,
      required this.groups});

  factory FirebaseIngredientDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseIngredientDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseIngredientDocumentToJson(this);

  static FirebaseIngredientDocument from(List<FirebaseIngredient> ingredients,
      String recipeID, List<FirebaseIngredientGroup> groups) {
    return FirebaseIngredientDocument(
        ingredients: ingredients, recipeID: recipeID, groups: groups);
  }
}
