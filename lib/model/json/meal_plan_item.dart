import 'package:cookly/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_plan_item.g.dart';

@JsonSerializable(includeIfNull: false)
class MealPlanItem {
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime date;

  @JsonKey(nullable: false)
  Map<String, int> recipeReferences;

  MealPlanItem({this.date, this.recipeReferences}) {
    assert(this.recipeReferences != null);
  }

  factory MealPlanItem.fromJson(Map<String, dynamic> json) =>
      _$MealPlanItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanItemToJson(this);
}
