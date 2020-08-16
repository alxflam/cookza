import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookly/model/entities/firebase/instruction_entity.dart';
import 'package:cookly/model/entities/firebase/recipe_entity.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/firebase/recipe/firebase_instruction.dart';
import 'package:cookly/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:cookly/services/firebase_provider.dart';
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
      var recipe = FirebaseRecipe(name: 'name');
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.name, 'name');
    },
  );

  test(
    'lazy ingredients getter',
    () async {
      var recipe = FirebaseRecipe(name: 'name');
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
      var recipe = FirebaseRecipe(name: 'name');
      recipe.documentID = 'DOCID';
      recipe.recipeGroupID = 'GROUPID';
      var cut = RecipeEntityFirebase.of(recipe);

      List<InstructionEntityFirebase> ingredients = [];
      ingredients.add(InstructionEntityFirebase.of(
          FirebaseInstruction(text: 'Some instruction')));
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
      var recipe = FirebaseRecipe(name: 'name');
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
      var recipe = FirebaseRecipe(name: 'name');
      recipe.creationDate = Timestamp.fromDate(creationDate);
      recipe.modificationDate = Timestamp.fromDate(modDate);
      var cut = RecipeEntityFirebase.of(recipe);

      expect(cut.creationDateFormatted, kDateFormatter.format(creationDate));
      expect(cut.modificationDateFormatted, kDateFormatter.format(modDate));
    },
  );
}
