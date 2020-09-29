import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'empty recipe',
    () async {
      var cut = MutableRecipe.empty();

      expect(cut.name, null);
      expect(cut.description, null);
      expect(cut.id, null);
      expect(cut.recipeCollectionId, null);
    },
  );

  test(
    'empty recipe set values',
    () async {
      var cut = MutableRecipe.empty();
      cut.name = 'My name';
      expect(cut.name, 'My name');
      cut.description = 'My desc';
      expect(cut.description, 'My desc');
      cut.recipeCollectionId = 'ref';
      expect(cut.recipeCollectionId, 'ref');
      cut.addTag('vegetarian');
      expect(cut.tags.contains('vegetarian'), true);
      var onion = MutableIngredientNote.empty();
      onion.name = 'Onion';
      cut.ingredientList = [onion];
      var ingredients = await cut.ingredients;
      expect(ingredients.length, 1);
      expect(ingredients.first.ingredient.name, 'Onion');
      var ins = MutableInstruction.empty();
      ins.text = 'Do this';
      ins.step = 1;
      cut.instructionList = [ins];
      var instructions = await cut.instructions;
      expect(instructions.length, 1);
      expect(instructions.first.text, 'Do this');
      expect(instructions.first.step, 1);
    },
  );

  test(
    'of constructor copies values',
    () async {
      var onion = MutableIngredientNote.empty();
      onion.name = 'Onion';

      var cut = MutableRecipe.of(RecipeEntityJson.of(Recipe(
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
      )));

      expect(cut.hasInMemoryImage, false);
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

  test(
    'use setters to set values',
    () async {
      var onion = MutableIngredientNote.empty();
      onion.name = 'Onion';

      var cut = MutableRecipe.empty();
      cut.name = 'My name';
      expect(cut.name, 'My name');
      cut.description = 'My desc';
      expect(cut.description, 'My desc');
      cut.id = 'ID';
      expect(cut.id, 'ID');
      cut.recipeCollectionId = 'collectionID';
      expect(cut.recipeCollectionId, 'collectionID');
      cut.instructionList = [MutableInstruction.withValues(text: 'First one')];
      var instructions = await cut.instructions;
      expect(instructions.length, 1);
      expect(instructions.first.text, 'First one');
      cut.ingredientList = [onion];
      var ingredients = await cut.ingredients;
      expect(ingredients.length, 1);
      expect(ingredients.first.ingredient.name, 'Onion');
      cut.servings = 3;
      expect(cut.servings, 3);
      cut.rating = 5;
      expect(cut.rating, 5);
      cut.addTag('delicious');
      expect(cut.tags, ['delicious']);
      cut.duration = 50;
      expect(cut.duration, 50);
    },
  );

  test(
    'tag handling',
    () async {
      var cut = MutableRecipe.empty();

      cut.addTag('tag1');
      expect(cut.tags.first, 'tag1');

      cut.removeTage('tag1');
      expect(cut.tags.isEmpty, true);

      cut.tags = ['tag2'];
      expect(cut.tags.first, 'tag2');
    },
  );

  test('Recipe with in memory image', () async {
    var onion = MutableIngredientNote.empty();
    onion.name = 'Onion';

    var cut = MutableRecipe.of(
        RecipeEntityJson.of(Recipe(serializedImage: '1010', id: '1234')));

    expect(cut.hasInMemoryImage, true);
    expect(cut.inMemoryImage.length, 3);
  });

  test('Dates are formatted', () async {
    var now = DateTime.now();
    var cut = MutableRecipe.of(RecipeEntityJson.of(Recipe(
      creationDate: now,
      modificationDate: now,
      id: '1234',
    )));

    expect(cut.creationDate, now);
    expect(cut.modificationDate, now);
    expect(cut.creationDateFormatted, kDateFormatter.format(now));
    expect(cut.modificationDateFormatted, kDateFormatter.format(now));
  });
}
