import 'dart:io';

import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/services/image_parser.dart';
import 'package:cookly/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class ImageTextExtractorMock extends Mock implements ImageTextExtractor {}

class FileMock extends Mock implements File {}

void main() {
  var mock = ImageTextExtractorMock();
  setUpAll(() {
    GetIt.I.registerSingleton<ImageTextExtractor>(mock);
  });

  test('Overview step', () async {
    var cut = RecipeOverviewOCRStep();
    var file = FileMock();
    var model = RecipeOverviewEditStep();
    model.name = 'Dummy';

    when(mock.processOverviewImage(file))
        .thenAnswer((_) => Future.value(model));

    await cut.setImage(file);

    expect(cut.isPending, false);
    expect(cut.isValid, true);
    expect(cut.image, file);
    expect(cut.model, model);
  });

  test('Ingredient step', () async {
    var cut = RecipeIngredientOCRStep();
    var file = FileMock();
    var model = RecipeIngredientEditStep();
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = 'Pepper';
    model.addNewIngredient(RecipeIngredientModel.of(ingredient));

    when(mock.processIngredientsImage(file))
        .thenAnswer((_) => Future.value(model));

    await cut.setImage(file);

    expect(cut.isPending, false);
    expect(cut.isValid, true);
    expect(cut.image, file);
    expect(cut.model, model);
  });

  test('Instruction step', () async {
    var cut = RecipeInstructionOCRStep();
    var file = FileMock();
    var model = RecipeInstructionEditStep();
    model.addInstruction('Do Something');

    when(mock.processInstructionsImage(file))
        .thenAnswer((_) => Future.value(model));

    await cut.setImage(file);

    expect(cut.isPending, false);
    expect(cut.isValid, true);
    expect(cut.image, file);
    expect(cut.model, model);
  });
}
