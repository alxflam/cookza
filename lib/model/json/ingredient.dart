import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(includeIfNull: false)
class Ingredient {
  @JsonKey()
  String name;

  @JsonKey()
  String? recipeReference;

  Ingredient({required this.name, this.recipeReference});

  Ingredient.from(Ingredient ingredient)
      : this.name = ingredient.name,
        this.recipeReference = ingredient.recipeReference;

  Ingredient.fromEntity(IngredientEntity ingredient)
      : this.name = ingredient.name,
        this.recipeReference = ingredient.recipeReference;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
