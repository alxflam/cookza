import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_collection.g.dart';

@JsonSerializable(includeIfNull: false)
class RecipeCollection {
  @JsonKey(nullable: false)
  String id;
  @JsonKey(nullable: false)
  String name;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationTimestamp;

  factory RecipeCollection.fromJson(Map<String, dynamic> json) {
    var instance = _$RecipeCollectionFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$RecipeCollectionToJson(this);

  RecipeCollection({
    this.id,
    this.name,
    this.creationTimestamp,
  }) {
    if (this.creationTimestamp == null) {
      this.creationTimestamp = Timestamp.now();
    }
  }
}
