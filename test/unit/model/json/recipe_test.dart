import 'dart:typed_data';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/file_mock.dart';
import '../../../mocks/shared_mocks.mocks.dart';

void main() {
  var mock = MockImageManager();

  setUpAll(() {
    GetIt.I.registerSingleton<ImageManager>(mock);
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
    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [pepper])
    ];

    recipe.name = 'Test';
    recipe.description = 'Desc';
    recipe.recipeCollectionId = '12';
    recipe.modificationDate = now;
    recipe.duration = 30;
    recipe.servings = 2;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.tags = ['veggie'];
    recipe.id = '1234';

    var cut = await Recipe.applyFrom(recipe);

    expect(cut.name, 'Test');
    expect(cut.shortDescription, 'Desc');
    expect(cut.recipeCollection, '12');
    expect(cut.modificationDate, now);
    expect(cut.duration, 30);
    expect(cut.servings, 2);
    expect(cut.diff, DIFFICULTY.HARD);
    expect(cut.tags.length, 1);
    expect(cut.tags.first, 'veggie');
    expect(cut.servings, 2);
    // TODO: remove ing member and replace with ing group!?
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
    recipe.recipeCollectionId = 'test';
    recipe.id = '1234';
    recipe.image = '/dummy/';

    var mockFile = FakeFile();
    mockFile.stubByteContent(Uint8List.fromList([1, 2, 3, 4]));

    when(mock.getRecipeImageFile(any)).thenAnswer((_) async => mockFile);

    var cut = await Recipe.applyFrom(recipe);

    expect(cut.serializedImage!.isNotEmpty, true);
    expect(cut.serializedImage, 'AQIDBA==');
  });
}
