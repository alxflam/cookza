import 'package:cookza/model/json/recipe_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Recipe list getter', () async {
    var cut = RecipeList(recipes: []);
    expect(cut.recipes, isNotNull);
    expect(cut.recipes.length, 0);
  });
}
