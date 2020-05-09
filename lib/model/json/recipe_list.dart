import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_list.g.dart';

@JsonSerializable(includeIfNull: false)
class RecipeList {
  @JsonKey(nullable: false)
  int modelVersion;

  @JsonKey(toJson: kListToJson)
  List<Recipe> recipes;

  RecipeList({this.modelVersion, this.recipes}) {
    this.modelVersion = 1;
    if (this.recipes == null) {
      this.recipes = [];
    }
  }

  factory RecipeList.fromJson(Map<String, dynamic> json) =>
      _$RecipeListFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeListToJson(this);
}
