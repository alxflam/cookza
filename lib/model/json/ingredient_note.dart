import 'package:cookly/model/json/ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_note.g.dart';

dynamic _toJson(Ingredient ingredient) {
  return ingredient.toJson();
}

@JsonSerializable(includeIfNull: false)
class IngredientNote {
  @JsonKey(nullable: false, toJson: _toJson)
  Ingredient ingredient;
  @JsonKey(defaultValue: '')
  String unitOfMeasure;
  @JsonKey(nullable: false)
  double amount;

  IngredientNote({this.ingredient, this.unitOfMeasure, this.amount});

  factory IngredientNote.fromJson(Map<String, dynamic> json) =>
      _$IngredientNoteFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientNoteToJson(this);
}
