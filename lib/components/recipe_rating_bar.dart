import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeRatingBar extends StatelessWidget {
  final int initialRating;
  final ValueChanged<double> onUpdate;

  const RecipeRatingBar(
      {Key? key, required this.initialRating, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(!kIsWeb); // not supported on web
    return RatingBar.builder(
      initialRating: initialRating.toDouble(),
      minRating: 0,
      maxRating: 5,
      direction: Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 20.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
      onRatingUpdate: onUpdate,
      updateOnDrag: false,
    );
  }
}