import 'dart:convert';

import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/ingredient_note_entity.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

abstract class ChefkochAccessor {
  Future<RecipeEntity> getRecipe(String id);
}

class ChefkochAccessorImpl implements ChefkochAccessor {
  static final String url = 'https://api.chefkoch.de/v2/recipes/';

  @override
  Future<RecipeEntity> getRecipe(String id) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.chefkoch.de',
      path: 'v2/recipes/$id',
    );
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      throw 'Error contacting Chefkoch.de - pleasy try again later';
    }

    var uoms = sl.get<UnitOfMeasureProvider>().getAll();

    var json = jsonDecode(response.body);
    int difficulty = json['difficulty'];
    DIFFICULTY diff = difficulty == 1
        ? DIFFICULTY.EASY
        : difficulty > 2
            ? DIFFICULTY.HARD
            : DIFFICULTY.MEDIUM;

    var recipe = Recipe(
      name: json['title'],
      shortDescription: json['subtitle'],
      diff: diff,
      servings: (json['servings']),
      duration: (json['totalTime']),
      instructions: [],
      ingredients: [],
      tags: [],
      recipeCollection: '',
      creationDate: DateTime.now(),
      modificationDate: DateTime.now(),
      id: '',
    );

    final result = MutableRecipe.of(RecipeEntityJson.of(recipe));

    var instructions = LineSplitter.split(json['instructions']);
    result.instructionList = instructions
        .where((e) => e.trim().isNotEmpty)
        .map((e) => MutableInstruction.withValues(text: e))
        .toList();

    var groupCounter = 0;
    final ingGroupList = <IngredientGroupEntity>[];
    for (var group in json['ingredientGroups']) {
      groupCounter++;

      final groupIngredients = <MutableIngredientNote>[];
      for (var ingredient in group['ingredients']) {
        var unit = ingredient['unit'] as String;
        var targetUom = uoms.firstWhereOrNull((e) => e.displayName == unit);
        final note = MutableIngredientNote.of(
          IngredientNoteEntityJson.of(
            IngredientNote(
              amount: ingredient['amount'],
              unitOfMeasure: targetUom != null ? targetUom.id : '',
              ingredient: Ingredient(name: ingredient['name']),
            ),
          ),
        );
        groupIngredients.add(note);
      }

      final ingGroup = MutableIngredientGroup.forValues(
          groupCounter, 'TODO', groupIngredients);
      ingGroupList.add(ingGroup);
    }

    result.ingredientGroupList = ingGroupList;

    return result;
  }
}
