import 'package:cookly/constants.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_list.g.dart';

@JsonSerializable(includeIfNull: false)
class ShoppingList {
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime dateFrom;
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime dateEnd;

  @JsonKey(nullable: false)
  Map<String, int> recipeReferences;

  @JsonKey(toJson: kListToJson)
  List<IngredientNote> availableIngredients;

  ShoppingList({this.dateFrom, this.dateEnd});

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}
