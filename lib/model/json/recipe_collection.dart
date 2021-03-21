import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_collection.g.dart';

@JsonSerializable(includeIfNull: false)
class RecipeCollection {
  @JsonKey()
  String id;
  @JsonKey()
  String name;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationTimestamp;

  factory RecipeCollection.fromJson(Map<String, dynamic> json) {
    var instance = _$RecipeCollectionFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$RecipeCollectionToJson(this);

  RecipeCollection({
    required this.id,
    required this.name,
  }) : this.creationTimestamp = Timestamp.now();
}
