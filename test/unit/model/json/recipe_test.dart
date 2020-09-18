import 'dart:io';
import 'dart:typed_data';

import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_instruction.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/file_mock.dart';
import '../../../mocks/image_manager_mock.dart';

void main() {
  var mock = ImageManagerMock();

  setUpAll(() {
    GetIt.I.registerSingleton<ImageManager>(mock);
    GetIt.I.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
  });

  test('Copy values from entity', () async {
    var recipe = MutableRecipe.empty();
    var now = DateTime.now();

    var pepper = MutableIngredientNote.empty();
    pepper.name = 'Pepper';
    pepper.amount = 3;
    pepper.unitOfMeasure = 'KGM';

    var instruction = MutableInstruction.empty();
    instruction.text = 'Something 2';

    recipe.instructionList = [instruction];
    recipe.ingredientList = [pepper];

    recipe.name = 'Test';
    recipe.description = 'Desc';
    recipe.recipeCollectionId = '12';
    recipe.modificationDate = now;
    recipe.duration = 30;
    recipe.rating = 3;
    recipe.servings = 2;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.tags = ['veggie'];

    var cut = await Recipe.applyFrom(recipe);

    expect(cut.name, 'Test');
    expect(cut.shortDescription, 'Desc');
    expect(cut.recipeCollection, '12');
    expect(cut.modificationDate, now);
    expect(cut.duration, 30);
    expect(cut.rating, 3);
    expect(cut.servings, 2);
    expect(cut.diff, DIFFICULTY.HARD);
    expect(cut.tags.length, 1);
    expect(cut.tags.first, 'veggie');
    expect(cut.servings, 2);
    expect(cut.ingredients.length, 1);
    expect(cut.instructions.length, 1);
    expect(cut.ingredients.first.ingredient.name, 'Pepper');
    expect(cut.ingredients.first.amount, 3);
    expect(cut.ingredients.first.unitOfMeasure, 'KGM');
    expect(cut.instructions.length, 1);
    expect(cut.instructions.first, 'Something 2');
    expect(cut.serializedImage, null);
  });

  test('Image is serialized in field', () async {
    var recipe = MutableRecipe.empty();

    recipe.image = '/dummy/';

    var mockFile = FileMock();

    when(mockFile.readAsBytesSync())
        .thenAnswer((_) => Uint8List.fromList([1, 2, 3, 4]));

    when(mock.getRecipeImageFile(any)).thenAnswer((_) async => mockFile);

    var cut = await Recipe.applyFrom(recipe);

    expect(cut.serializedImage.isNotEmpty, true);
    expect(cut.serializedImage, 'AQIDBA==');
  });
}
