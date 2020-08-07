import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/recipe_text_generator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';

void main() {
  Map<String, dynamic> translations = {};
  translations.putIfAbsent(
      'recipe',
      () => {
            'ingredient': {'else': 'ingredient'}
          });
  Localization.load(translations);
  GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());

  var cut = RecipeTextGeneratorImpl();

  test('createRecipeText', () async {
    var recipe = MutableRecipe.empty();

    recipe.name = 'A recipe name';
    recipe.description = 'A description';

    var result = await cut.generateRecipeText([recipe]);
    var expectedResult = '''*A recipe name*
A description

*ingredient*

*recipe.instructions*


''';

    expect(result, expectedResult);
  });
}
