import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'empty recipe',
    () async {
      var cut = MutableRecipe.empty();
      cut.recipeCollectionId = 'C1';

      expect(cut.name, '');
      expect(cut.description, '');
      expect(cut.id, null);
      expect(cut.recipeCollectionId, 'C1');
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
      cut.ingredientGroupList = [
        MutableIngredientGroup.forValues(1, 'Test', [onion])
      ];

      var ingGroups = await cut.ingredientGroups;
      expect(ingGroups.length, 1);
      expect(ingGroups.first.ingredients.first.ingredient.name, 'Onion');
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

      var cut = MutableRecipe.empty();
      cut.id = 'ID';
      cut.name = 'My name';
      expect(cut.name, 'My name');
      cut.description = 'My desc';
      expect(cut.description, 'My desc');
      cut.recipeCollectionId = 'collectionID';
      expect(cut.recipeCollectionId, 'collectionID');
      cut.addTag('delicious');
      expect(cut.tags.contains('delicious'), true);
      cut.ingredientGroupList = [
        MutableIngredientGroup.forValues(1, 'Test', [onion])
      ];
      var ins = MutableInstruction.empty();
      ins.text = 'First one';
      ins.step = 1;
      cut.instructionList = [ins];
      cut.servings = 3;
      cut.duration = 50;

      var copy = await MutableRecipe.createFrom(cut);

      expect(copy.hasInMemoryImage, false);
      expect(copy.name, 'My name');
      expect(copy.description, 'My desc');
      expect(copy.id, 'ID');
      expect(copy.recipeCollectionId, 'collectionID');
      var instructions = await copy.instructions;
      expect(instructions.length, 1);
      expect(instructions.first.text, 'First one');
      var ingGroups = await copy.ingredientGroups;
      expect(ingGroups.length, 1);
      expect(ingGroups.first.ingredients.first.ingredient.name, 'Onion');
      expect(copy.servings, 3);
      expect(copy.tags, ['delicious']);
      expect(copy.duration, 50);
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
      cut.ingredientGroupList = [
        MutableIngredientGroup.forValues(1, 'Test', [onion])
      ];

      var ingGroups = await cut.ingredientGroups;
      expect(ingGroups.length, 1);
      expect(ingGroups.first.ingredients.first.ingredient.name, 'Onion');
      cut.servings = 3;
      expect(cut.servings, 3);
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

    var cut = await MutableRecipe.createFrom(RecipeEntityJson.of(Recipe(
      serializedImage: '1010',
      id: '1234',
      creationDate: DateTime.now(),
      diff: DIFFICULTY.EASY,
      duration: 20,
      ingredientGroups: [],
      instructions: [],
      modificationDate: DateTime.now(),
      name: '',
      recipeCollection: '',
      servings: 2,
      shortDescription: '',
      tags: [],
    )));

    expect(cut.hasInMemoryImage, true);
    expect(cut.inMemoryImage.length, 3);
  });

  test('Dates are formatted', () async {
    var now = DateTime.now();
    var cut = await MutableRecipe.createFrom(RecipeEntityJson.of(Recipe(
      serializedImage: '1010',
      id: '1234',
      creationDate: DateTime.now(),
      diff: DIFFICULTY.EASY,
      duration: 20,
      ingredientGroups: [],
      instructions: [],
      modificationDate: DateTime.now(),
      name: '',
      recipeCollection: '',
      servings: 2,
      shortDescription: '',
      tags: [],
    )));

    expect(DateUtils.isSameDay(cut.creationDate, now), true);
    expect(DateUtils.isSameDay(cut.modificationDate, now), true);
    expect(cut.creationDateFormatted, kDateFormatter.format(now));
    expect(cut.modificationDateFormatted, kDateFormatter.format(now));
  });
}
