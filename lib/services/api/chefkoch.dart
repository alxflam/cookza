import 'dart:convert';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:http/http.dart' as http;

class Chefkoch {
  static final String url = 'https://api.chefkoch.de/v2/recipes/';

  Future<RecipeEntity> getRecipe(String id) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.chefkoch.de',
      path: 'v2/recipes/$id',
    );
    var result = await http.get(uri);
    if (result.statusCode != 200) {
      throw 'Error contacting Chefkoch.de - pleasy try again later';
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
        : difficulty > 2
            ? DIFFICULTY.HARD
            : DIFFICULTY.MEDIUM);
    recipe.servings = (json['servings']);
    recipe.duration = (json['totalTime']);

    var instructions = LineSplitter.split(json['instructions']);

    instructions.forEach((element) => recipe.instructions.add(element));

    for (var group in json['ingredientGroups']) {
      for (var ingredient in group['ingredients']) {
        var unit = ingredient['unit'] as String;
        var targetUom =
            uoms.firstWhere((e) => e.displayName == unit, orElse: () => null);

        recipe.ingredients.add(IngredientNote(
            amount: ingredient['amount'],
            unitOfMeasure: targetUom != null ? targetUom.id : '',
            ingredient: Ingredient(name: ingredient['name'])));
      }
    }

    return RecipeEntityJson.of(recipe);
  }
}
