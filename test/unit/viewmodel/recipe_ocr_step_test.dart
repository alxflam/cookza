import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/image_parser.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/file_mock.dart';
import '../../mocks/shared_mocks.mocks.dart';

void main() {
  var mock = MockImageTextExtractor();
  setUpAll(() {
    GetIt.I.registerSingleton<ImageTextExtractor>(mock);
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('Overview step', () async {
    var cut = RecipeOverviewOCRStep();
    var file = FakeFile();
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
    var file = FakeFile();
    var model = RecipeIngredientEditStep();
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = 'Pepper';
    final group = model.addGroup('');
    model.addNewIngredient(RecipeIngredientModel.of(ingredient), group);

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
    var file = FakeFile();
    var model = RecipeInstructionEditStep();
    model.addInstruction('Do Something');

    when(mock.processInstructionsImage(file,
            recipeDescription: anyNamed('recipeDescription'),
            recipeTitle: anyNamed('recipeTitle')))
        .thenAnswer((_) => Future.value(model));

    await cut.setImage(file);

    expect(cut.isPending, false);
    expect(cut.isValid, true);
    expect(cut.image, file);
    expect(cut.model, model);
  });
}
