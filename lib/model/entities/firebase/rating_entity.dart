import 'package:cookza/model/entities/abstract/rating_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_rating.dart';

class RatingEntityFirebase implements RatingEntity {
  final FirebaseRating _rating;

  RatingEntityFirebase.of(this._rating);

  @override
  int get rating => this._rating.rating;

  @override
  String get recipeId => this._rating.recipeId;

  @override
  String get userId => this._rating.userId;
}
