import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/model/firebase/recipe/firebase_recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Recipe from and to JSON',
    () async {
      var json = {
        'creationDate': Timestamp.now(),
        'modificationDate': Timestamp.now(),
        'name': 'Name',
        'ingredientsID': null,
        'instructionsID': null,
        'description': 'Description',
        'duration': 40,
        'rating': 4,
        'servings': 2,
        'image': '/image/',
        'recipeGroupID': '1234',
        'difficulty': 'EASY',
        'tags': ['someTag']
      };
      var cut = FirebaseRecipe.fromJson(json);
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );

  test(
    'Recipe from Entity',
    () async {
      var recipe = MutableRecipe.empty();
      recipe.name = 'Name';

      var cut = FirebaseRecipe.from(recipe);

      expect(cut.name, 'Name');
    },
  );
}