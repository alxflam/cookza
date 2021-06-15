import 'package:cookza/constants.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_group.g.dart';

@JsonSerializable(includeIfNull: false)
class IngredientGroup {
  @JsonKey(toJson: kListToJson)
  List<IngredientNote> ingredients;
  @JsonKey()
  String name;

  IngredientGroup({required this.name, required this.ingredients});

  factory IngredientGroup.fromJson(Map<String, dynamic> json) {
    return _$IngredientGroupFromJson(json);
  }

  Map<String, dynamic> toJson() => _$IngredientGroupToJson(this);
}
