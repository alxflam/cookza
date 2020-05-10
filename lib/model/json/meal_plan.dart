import 'package:cookly/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cookly/model/json/meal_plan_item.dart';

part 'meal_plan.g.dart';

@JsonSerializable(includeIfNull: false)
class MealPlan {
  @JsonKey(nullable: false)
  int modelVersion;

  @JsonKey(toJson: kListToJson)
  List<MealPlanItem> items;

  MealPlan({this.modelVersion, this.items}) {
    this.modelVersion = 1;
    if (this.items == null) {
      this.items = [];
    }
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanToJson(this);
}
