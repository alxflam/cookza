import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookza/model/entities/firebase/instruction_entity.dart';
import 'package:cookza/model/entities/firebase/recipe_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookza/model/firebase/recipe/firebase_instruction.dart';
import 'package:cookza/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/firebase_provider_mock.dart';

void main() {
  var fbMock = FirebaseProviderMock();
  GetIt.I.registerSingleton<FirebaseProvider>(fbMock);

  test(
    'Collection with single user',
    () async {
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.name, 'name');
    },
  );

  test(
    'lazy ingredients getter',
    () async {
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      recipe.documentID = 'DOCID';
      recipe.recipeGroupID = 'GROUPID';
      var cut = RecipeEntityFirebase.of(recipe);

      List<IngredientNoteEntityFirebase> ingredients = [];
      ingredients.add(IngredientNoteEntityFirebase.of(FirebaseIngredient(
          amount: 2,
          unitOfMeasure: 'KGM',
          ingredient: Ingredient(name: 'Onion'))));

      when(fbMock.recipeIngredients('GROUPID', 'DOCID'))
          .thenAnswer((_) => Future.value(ingredients));

      var result = await cut.ingredients;
      expect(result.length, 1);
      verify(fbMock.recipeIngredients('GROUPID', 'DOCID')).called(1);

      // second invocation won't call firebase provider again
      result = await cut.ingredients;
      expect(result.length, 1);
      verifyNever(fbMock.recipeIngredients('GROUPID', 'DOCID'));
    },
  );

  test(
    'lazy instructions getter',
    () async {
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      recipe.documentID = 'DOCID';
      recipe.recipeGroupID = 'GROUPID';
      var cut = RecipeEntityFirebase.of(recipe);

      List<InstructionEntityFirebase> ingredients = [];
      ingredients.add(InstructionEntityFirebase.of(
          FirebaseInstruction(text: 'Some instruction', step: 1)));
      when(fbMock.recipeInstructions('GROUPID', 'DOCID'))
          .thenAnswer((_) => Future.value(ingredients));

      var result = await cut.instructions;
      expect(result.length, 1);
      expect(result.first.text, 'Some instruction');
      verify(fbMock.recipeInstructions('GROUPID', 'DOCID')).called(1);

      // second invocation won't call firebase provider again
      result = await cut.instructions;
      expect(result.length, 1);
      expect(result.first.text, 'Some instruction');
      verifyNever(fbMock.recipeInstructions('GROUPID', 'DOCID'));
    },
  );

  test(
    'never has in memory image',
    () async {
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.hasInMemoryImage, false);
      expect(cut.inMemoryImage, null);
    },
  );

  test(
    'formatted date getters',
    () async {
      var creationDate = DateTime.now();
      var modDate = creationDate.add(Duration(days: 1));
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      recipe.creationDate = Timestamp.fromDate(creationDate);
      recipe.modificationDate = Timestamp.fromDate(modDate);
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.creationDateFormatted, kDateFormatter.format(creationDate));
      expect(cut.modificationDateFormatted, kDateFormatter.format(modDate));
    },
  );

  test(
    'basic getters',
    () async {
      var recipe = FirebaseRecipe(
        name: 'name',
        creationDate: Timestamp.now(),
        description: '',
        difficulty: DIFFICULTY.EASY,
        duration: 20,
        image: '',
        modificationDate: Timestamp.now(),
        rating: 2,
        recipeGroupID: '',
        servings: 2,
        tags: [],
      );
      recipe.rating = 3;
      recipe.servings = 4;
      recipe.recipeGroupID = '1234';
      recipe.tags = ['someTag'];
      recipe.image = '/some/img.jpg';
      recipe.documentID = '4567';
      recipe.instructionsID = '77';
      recipe.ingredientsID = '99';
      recipe.description = 'Desc';
      recipe.duration = 55;
      recipe.difficulty = DIFFICULTY.HARD;
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.description, 'Desc');
      expect(cut.instructionsID, '77');
      expect(cut.ingredientsID, '99');
      expect(cut.duration, 55);
      expect(cut.rating, 3);
      expect(cut.servings, 4);
      expect(cut.recipeCollectionId, '1234');
      expect(cut.tags.length, 1);
      expect(cut.tags.first, 'someTag');
      expect(cut.image, '/some/img.jpg');
      expect(cut.id, '4567');
      expect(cut.difficulty, DIFFICULTY.HARD);
    },
  );
}
