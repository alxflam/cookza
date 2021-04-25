// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseRating _$FirebaseRatingFromJson(Map<String, dynamic> json) {
  return FirebaseRating(
    userId: json['userId'] as String,
    recipeId: json['recipeId'] as String,
    rating: json['rating'] as int,
  );
}

Map<String, dynamic> _$FirebaseRatingToJson(FirebaseRating instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'recipeId': instance.recipeId,
      'rating': instance.rating,
    };
