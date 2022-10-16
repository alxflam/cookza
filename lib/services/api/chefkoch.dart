import 'dart:convert';

import 'package:cookza/constants.dart';
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
import 'package:cookza/services/api/registry.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

abstract class ChefkochImporter extends RecipeIntentImporter {}

class ChefkochImporterImpl implements ChefkochImporter {
  static const String url = 'https://api.chefkoch.de/v2/recipes/';
  static final exp = RegExp(r'rezepte\/([0-9]*)\/');

  @override
  bool canHandle(String intentData) {
    var matches = exp.allMatches(intentData);
    return matches.isNotEmpty;
  }

  @override
  Future<RecipeEntity> getRecipe(String intentData) async {
    var matches = exp.allMatches(intentData);
    var match = matches.first;
    var id = intentData.substring(match.start + 8, match.end - 1);

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

    var duration = adaptRecipeDuration((json['totalTime']));

    var recipe = Recipe(
      name: json['title'],
      shortDescription: json['subtitle'],
      diff: diff,
      servings: (json['servings']),
      duration: duration,
      instructions: [],
      ingredientGroups: [],
      tags: [],
      recipeCollection: '',
      creationDate: DateTime.now(),
      modificationDate: DateTime.now(),
      id: '',
    );

    final result = await MutableRecipe.createFrom(RecipeEntityJson.of(recipe));

    var instructions = LineSplitter.split(json['instructions']);
    result.instructionList = instructions
        .where((e) => e.trim().isNotEmpty)
        .map((e) => MutableInstruction.withValues(text: e))
        .toList();

    // map UOMs from chefkoch to cookza
    final uomProvider = sl.get<UnitOfMeasureProvider>();
    final unitMap = {
      '4': uomProvider.getUnitOfMeasureById('MLT'),
      '13': uomProvider.getUnitOfMeasureById('G24'),
      '14': uomProvider.getUnitOfMeasureById('G25'),
      '164': uomProvider.getUnitOfMeasureById('G25'),
      '58': uomProvider.getUnitOfMeasureById('G25'),
      '156': uomProvider.getUnitOfMeasureById('CA'),
      '48': uomProvider.getUnitOfMeasureById('HAN'),
      '224': uomProvider.getUnitOfMeasureById('G21'),
      '165': uomProvider.getUnitOfMeasureById('LTR'),
      '3': uomProvider.getUnitOfMeasureById('GRM'),
      '169': uomProvider.getUnitOfMeasureById('PA'),
      '179': uomProvider.getUnitOfMeasureById('LEF'),
      '11': uomProvider.getUnitOfMeasureById('G21'),
      '26': uomProvider.getUnitOfMeasureById('CLO'),
      '16': uomProvider.getUnitOfMeasureById('X2'),
      '106': uomProvider.getUnitOfMeasureById('PIN'),
      '150': uomProvider.getUnitOfMeasureById('TWG'),
      '126': uomProvider.getUnitOfMeasureById('14'),
      '31': uomProvider.getUnitOfMeasureById('GLA'),
      '87': uomProvider.getUnitOfMeasureById('H87'),
    };

    var groupCounter = 0;
    final ingGroupList = <IngredientGroupEntity>[];
    for (var group in json['ingredientGroups']) {
      groupCounter++;
      var groupName = group['header']?.toString().trim();
      groupName = (groupName == null || groupName.isEmpty)
          ? 'Group $groupCounter'
          : groupName;

      final groupIngredients = <MutableIngredientNote>[];
      for (var ingredient in group['ingredients']) {
        var unit = ingredient['unit'] as String;
        var unitId = ingredient['unitId'] as String?;
        UnitOfMeasure? targetUom;

        // try to get the UOM by the mapping table, if the ID is known
        if (unitId?.isNotEmpty ?? false) {
          targetUom = unitMap[unitId];
        }

        // else try to find a matching UOM by its label
        targetUom ??= uoms.firstWhereOrNull(
            (e) => e.displayName.toLowerCase() == unit.toLowerCase());

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
          groupCounter, groupName, groupIngredients);
      ingGroupList.add(ingGroup);
    }

    result.ingredientGroupList = ingGroupList;

    return result;
  }
}
