import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_handshake.g.dart';

@JsonSerializable()
class FirebaseHandshake {
  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(nullable: false)
  String requestor;
  @JsonKey(nullable: false)
  String owner;
  @JsonKey(fromJson: kTimestampFromJson, toJson: kTimestampToJson)
  Timestamp creationTimestamp;
  @JsonKey(nullable: false)
  String operatingSystem;
  @JsonKey(nullable: false)
  String browser;

  factory FirebaseHandshake.fromJson(Map<String, dynamic> json, String id) {
    var instance = _$FirebaseHandshakeFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseHandshakeToJson(this);

  FirebaseHandshake(
      {this.requestor,
      this.owner,
      this.creationTimestamp,
      this.operatingSystem,
      this.browser}) {
    if (this.creationTimestamp == null) {
      throw 'a handshake document can not be created without a timestamp';
    }
  }
}
