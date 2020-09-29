import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Create Recipe',
    () async {
      var onion = MutableIngredientNote.empty();
      onion.name = 'Onion';

      var cut = RecipeEntityJson.of(Recipe(
        creationDate: DateTime.now(),
        modificationDate: DateTime.now(),
        name: 'My name',
        shortDescription: 'My desc',
        duration: 50,
        diff: DIFFICULTY.HARD,
        id: 'ID',
        recipeCollection: 'collectionID',
        instructions: ['First one'],
        ingredients: [IngredientNote.fromEntity(onion)],
        servings: 3,
        rating: 5,
        tags: ['delicious'],
        serializedImage: '1010',
      ));

      expect(
          cut.creationDateFormatted, kDateFormatter.format(cut.creationDate));

      expect(cut.modificationDateFormatted,
          kDateFormatter.format(cut.modificationDate));
      // json recipe entity never has an image path
      expect(cut.image, '');
      // but it may contain an in memory image
      expect(cut.inMemoryImage.length, 3);
      expect(cut.hasInMemoryImage, true);
      expect(cut.imageAsBytes.length, 3);

      expect(cut.difficulty, DIFFICULTY.HARD);
      expect(cut.name, 'My name');
      expect(cut.description, 'My desc');
      expect(cut.id, 'ID');
      expect(cut.recipeCollectionId, 'collectionID');
      var instructions = await cut.instructions;
      expect(instructions.length, 1);
      expect(instructions.first.text, 'First one');
      var ingredients = await cut.ingredients;
      expect(ingredients.length, 1);
      expect(ingredients.first.ingredient.name, 'Onion');
      expect(cut.servings, 3);
      expect(cut.rating, 5);
      expect(cut.tags, ['delicious']);
      expect(cut.duration, 50);
    },
  );
}
