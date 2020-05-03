import 'package:cookly/components/recipe_card.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return RecipeCard();
      },
      itemCount: 1,
    );
  }
}
