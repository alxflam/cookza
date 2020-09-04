import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_instruction.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/recipe_text_generator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/uom_provider_mock.dart';

void main() {
  Map<String, dynamic> translations = {};
  translations.putIfAbsent(
      'recipe',
      () => {
            'ingredient': {'else': 'ingredient'}
          });
  Localization.load(translations);
  GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());

  var cut = RecipeTextGeneratorImpl();

  test('createRecipeText', () async {
    var recipe = MutableRecipe.empty();

    recipe.name = 'A recipe name';
    recipe.description = 'A description';

    recipe.instructionList = [
      MutableInstruction.withValues(text: 'First step', step: 1),
      MutableInstruction.withValues(text: 'Second step', step: 2)
    ];

    var pepper = MutableIngredientNote.empty();
    pepper.name = 'Pepper';
    pepper.amount = 4;
    pepper.unitOfMeasure = 'GRM';

    var onion = MutableIngredientNote.empty();
    onion.name = 'Onion';
    onion.amount = 2;
    onion.unitOfMeasure = 'PCS';

    recipe.ingredientList = [pepper, onion];

    var result = await cut.generateRecipeText([recipe]);
    var expectedResult = '''*A recipe name*
A description

*ingredient*
• Pepper (4 GRM)
• Onion (2 PCS)

*recipe.instructions*
1. First step
2. Second step
''';

    expect(result, expectedResult);
  });
}
