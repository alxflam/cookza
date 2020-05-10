import 'package:cookly/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_plan_item.g.dart';

@JsonSerializable(includeIfNull: false)
class MealPlanItem {
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime creationDate;

  @JsonKey(nullable: false)
  String recipeReference;

  MealPlanItem({this.creationDate, this.recipeReference}) {
    assert(this.recipeReference != null && this.recipeReference.isNotEmpty);
  }

  factory MealPlanItem.fromJson(Map<String, dynamic> json) =>
      _$MealPlanItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanItemToJson(this);
}
