import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(() {
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('Tag step - tag setters', () async {
    var cut = RecipeTagEditStep();

    expect(cut.isVegan, false);
    expect(cut.isVegetarian, false);
    expect(cut.containsFish, false);
    expect(cut.containsMeat, false);

    cut.setVegan(true);
    expect(cut.isVegan, true);
    expect(cut.isVegetarian, true);

    cut.setVegetarian(true);
    expect(cut.isVegan, false);
    expect(cut.isVegetarian, true);

    cut.setContainsFish(true);
    expect(cut.containsFish, true);
    expect(cut.isVegetarian, false);

    cut.setContainsMeat(true);
    expect(cut.containsFish, true);
    expect(cut.containsMeat, true);

    cut.setContainsFish(false);
    expect(cut.containsFish, false);
    expect(cut.containsMeat, true);
  });

  test('Overview step - OCR', () async {
    var cut = RecipeOverviewEditStep();

    expect(cut.hasOCR, true);
  });

  test('Ingredient step - OCR', () async {
    var cut = RecipeIngredientEditStep();

    expect(cut.hasOCR, true);
  });

  test('Instruction step - OCR', () async {
    var cut = RecipeInstructionEditStep();

    expect(cut.hasOCR, true);
  });
}
