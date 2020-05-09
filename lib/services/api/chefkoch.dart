import 'dart:convert';

import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:http/http.dart' as http;

class Chefkoch {
  static final String url = 'https://api.chefkoch.de/v2/recipes/';

  Future<Recipe> getRecipe(String id) async {
    var result = await http.get('$url$id');
    if (result.statusCode != 200) {
      throw "Error contacting Chefkoch.de - pleasy try again later";
    }

    var uoms = sl.get<UnitOfMeasureProvider>().getAll();

    var json = jsonDecode(result.body);

    var recipe = Recipe();

    recipe.name = json['title'];
    recipe.shortDescription = json['subtitle'];
    recipe.rating = (double.parse(json['rating']['rating'].toString()).toInt());
    int difficulty = json['difficulty'];
    recipe.diff = (difficulty == 1
        ? DIFFICULTY.EASY
        : difficulty > 2 ? DIFFICULTY.HARD : DIFFICULTY.MEDIUM);
    recipe.servings = (json['servings']);
    recipe.duration = (json['totalTime']);

    List<String> instructions =
        LineSplitter.split(json['instructions'].toString());

    instructions.forEach((element) => recipe.instructions.add(element));

    for (var group in json['ingredientGroups']) {
      for (var ingredient in group['ingredients']) {
        var unit = ingredient['unit'] as String;
        var targetUom =
            uoms.firstWhere((e) => e.displayName == unit, orElse: () => null);

        recipe.ingredients.add(IngredientNote(
            amount: ingredient['amount'],
            unitOfMeasure: targetUom != null ? targetUom.id : '',
            ingredient: ingredient['name']));
      }
    }

    return recipe;
  }
}
