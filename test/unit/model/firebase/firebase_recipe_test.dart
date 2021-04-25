import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/firebase/recipe/firebase_recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Recipe from and to JSON',
    () async {
      var json = {
        'creationDate': Timestamp.now(),
        'modificationDate': Timestamp.now(),
        'name': 'Name',
        'description': 'Description',
        'duration': 40,
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
      recipe.id = '1234';
      recipe.recipeCollectionId = '456';
      recipe.name = 'Name';

      var cut = FirebaseRecipe.from(recipe);

      expect(cut.name, 'Name');
    },
  );
}
