import 'package:cookza/constants.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_list.g.dart';

@JsonSerializable(includeIfNull: false)
class RecipeList {
  @JsonKey()
  int modelVersion;

  @JsonKey(toJson: kListToJson)
  List<Recipe> recipes;

  RecipeList({required this.recipes}) : this.modelVersion = 1;

  factory RecipeList.fromJson(Map<String, dynamic> json) =>
      _$RecipeListFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeListToJson(this);
}
