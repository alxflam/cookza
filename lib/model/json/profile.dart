import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @JsonKey(toJson: kListToJson)
  List<Recipe> recipes;

  Profile({this.recipes});
}
