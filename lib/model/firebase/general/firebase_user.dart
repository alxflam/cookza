import 'package:json_annotation/json_annotation.dart';

part 'firebase_user.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseRecipeUser {
  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(nullable: false)
  String id;
  @JsonKey(nullable: false)
  String name;

  FirebaseRecipeUser({this.name, this.id});

  factory FirebaseRecipeUser.fromJson(Map<String, dynamic> json, {String id}) {
    var instance = _$FirebaseRecipeUserFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseRecipeUserToJson(this);
}
