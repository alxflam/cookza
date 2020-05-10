import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(includeIfNull: false)
class Ingredient {
  @JsonKey(nullable: false)
  String name;

  @JsonKey(nullable: true)
  String recipeReference;

  @JsonKey(nullable: true)
  int kal;

  Ingredient({this.name, this.kal, this.recipeReference});

  Ingredient.from(Ingredient ingredient) {
    this.name = ingredient.name;
    this.recipeReference = ingredient.recipeReference;
    this.kal = ingredient.kal;
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
