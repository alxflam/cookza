import 'package:json_annotation/json_annotation.dart';

part 'firebase_rating.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseRating {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? documentID;
  @JsonKey()
  String userId;
  @JsonKey()
  String recipeId;
  @JsonKey()
  int rating;

  FirebaseRating(
      {this.documentID,
      required this.userId,
      required this.recipeId,
      required this.rating});

  factory FirebaseRating.fromJson(Map<String, dynamic> json, {String? id}) {
    var instance = _$FirebaseRatingFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseRatingToJson(this);
}
