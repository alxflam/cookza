import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/model/firebase/general/firebase_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_recipe_collection.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseRecipeCollection {
  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(nullable: false)
  String name;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationTimestamp;
  @JsonKey(nullable: false)
  Map<String, String> users;

  factory FirebaseRecipeCollection.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseRecipeCollectionFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseRecipeCollectionToJson(this);

  FirebaseRecipeCollection({
    this.name,
    this.creationTimestamp,
    this.users,
  }) {
    if (this.creationTimestamp == null) {
      this.creationTimestamp = Timestamp.now();
    }
    if (this.users.isEmpty) {
      throw 'a recipe collection without users can not be created';
    }
  }
}