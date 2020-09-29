import 'package:cookza/model/json/recipe_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Recipe list is initialized if no vaue is given', () async {
    var cut = RecipeList();
    expect(cut.recipes, isNotNull);
    expect(cut.recipes.length, 0);
  });
}
