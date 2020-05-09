import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

dynamic _toJson(RecipeList recipes) {
  return recipes.toJson();
}

@JsonSerializable()
class Profile {
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @JsonKey(nullable: false, toJson: _toJson)
  RecipeList recipeList;

  Profile({this.recipeList});
}
