import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_note.g.dart';

dynamic _toJson(Ingredient ingredient) {
  return ingredient.toJson();
}

@JsonSerializable(includeIfNull: false)
class IngredientNote {
  @JsonKey(toJson: _toJson)
  Ingredient ingredient;
  @JsonKey(defaultValue: '')
  String unitOfMeasure;
  @JsonKey()
  double amount;

  IngredientNote({this.ingredient, this.unitOfMeasure, this.amount});

  IngredientNote.fromEntity(IngredientNoteEntity note) {
    this.ingredient = Ingredient.fromEntity(note.ingredient);
    this.amount = note.amount;
    this.unitOfMeasure = note.unitOfMeasure;
  }

  factory IngredientNote.fromJson(Map<String, dynamic> json) =>
      _$IngredientNoteFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientNoteToJson(this);
}
