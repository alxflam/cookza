import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_meal_plan_collection.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseMealPlanCollection {
  @JsonKey(ignore: true)
  String? documentID;
  @JsonKey()
  String name;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationTimestamp;
  @JsonKey()
  Map<String, String> users;

  factory FirebaseMealPlanCollection.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseMealPlanCollectionFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseMealPlanCollectionToJson(this);

  FirebaseMealPlanCollection({
    required this.name,
    required this.users,
  }) : this.creationTimestamp = Timestamp.now() {
    if (this.creationTimestamp == null) {
      this.creationTimestamp = Timestamp.now();
    }
    if (this.users.isEmpty) {
      throw 'a meal plan collection without users can not be created';
    }
    if (this.name.isEmpty) {
      throw 'a meal plan collection without name can not be created';
    }
  }
}
