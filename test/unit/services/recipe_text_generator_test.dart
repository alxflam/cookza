import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/services/recipe/recipe_text_generator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/uom_provider_mock.dart';

void main() {
  GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());

  var cut = RecipeTextGeneratorImpl();

  test('createRecipeText - single group', () async {
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

    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [pepper, onion])
    ];

    var ingTitle = 'Ingredients';
    var insTitle = 'Instructions';

    var result = await cut.generateRecipeText([recipe], ingTitle, insTitle);
    var expectedResult = '''*A recipe name*
A description

*$ingTitle*
• Pepper (4 GRM)
• Onion (2 PCS)

*$insTitle*
1. First step
2. Second step
''';

    expect(result, expectedResult);
  });

  test('createRecipeText - two ingredient groups', () async {
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

    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Group1', [pepper]),
      MutableIngredientGroup.forValues(1, 'Group2', [onion])
    ];

    var ingTitle = 'Ingredients';
    var insTitle = 'Instructions';

    var result = await cut.generateRecipeText([recipe], ingTitle, insTitle);
    var expectedResult = '''*A recipe name*
A description

*$ingTitle*
*Group1*
• Pepper (4 GRM)
*Group2*
• Onion (2 PCS)

*$insTitle*
1. First step
2. Second step
''';

    expect(result, expectedResult);
  });
}
