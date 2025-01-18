import 'dart:convert';

import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/instruction_entity.dart';
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
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

abstract class HomeConnectImporter extends RecipeIntentImporter {}

class HomeConnectImporterImpl implements HomeConnectImporter {
  final exp = RegExp(r'https:\/\/qr\.home-connect\.com\/\?(\w+)');
  final fusedDecoder = utf8.fuse(base64);
  final amountAndUnitRegex = RegExp(r'^(\d+) (\w+)');

  @override
  bool canHandle(String intentData) {
    return intentData.startsWith("https://home-connect.recipes/");
  }

  @override
  Future<RecipeEntity> getRecipe(String url) async {
    // resolve the shared URL
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      throw 'Error contacting $uri';
    }

    // the body contains a link with a base64 encoded intent string
    // e.g. 'https://qr.home-connect.com/?aG9tZWNvbm5lY3Q6Ly9vcGVuUmVjaXBlP3NvdXJjZUlkPTZhZGJmMzNlLWFiOWItNWVhNS05ZWY0LWY0YzlkZjQzZWEyMD9zaGFyZWQ';
    // which is decoded into e.g. "homeconnect://openRecipe?sourceId=6adbf33e-ab9b-5ea5-9ef4-f4c9df43ea20?shared"
    var body = response.body;
    var firstMatch = exp.firstMatch(body);
    if (firstMatch == null) {
      throw 'Unexpected intent data - recipe cannot be imported';
    }

    var match = firstMatch.group(1)?.trim();
    // normalization is required to pad the base64 string (length is multiple of four)
    var decoded = fusedDecoder.decode(base64.normalize(match ?? ''));

    // then retrieve the recipe ID from the decoded URL
    var res = Uri.parse(decoded);
    var recipeId = res.queryParameters['sourceId'];
    var index = recipeId?.indexOf('?shared');
    if (index != null && index >= 0) {
      recipeId = recipeId?.substring(0, index);
    }

    // get an anonymous auth token
    final authUri = Uri(
      scheme: 'https',
      host: 'prod.reu.rest.homeconnectegw.com',
      path: 'account/anonymous',
    );

    var authResponse = await http.post(
      authUri,
      headers: {
        'Accept-Language': 'de-DE',
        'Accept': 'application/vnd.bsh.hca.v1+json',
        'Content-Type': 'application/vnd.bsh.hca.v1+json'
      },
      body: jsonEncode(
        {
          'clientId':
              '9B75AC9EC512F36C84256AC47D813E2C1DD0D6520DF774B020E1E6E2EB29B1F3',
          'instanceId': const Uuid().v4()
        },
      ),
    );

    if (authResponse.statusCode != 200) {
      throw 'Error contacting $authUri';
    }

    // the response is a JSON
    var authJson = jsonDecode(authResponse.body);
    var token = authJson['data']['tokenData']['access_token'];

    // construct the recipe URL
    final recipeUri = Uri(
      scheme: 'https',
      host: 'prod.reu.rest.homeconnectegw.com',
      path: 'discover-webapp/api/recipe-details/$recipeId',
    );

    // and retrieve the recipe JSON using the anonymous authentication token
    var recipeResponse = await http.get(recipeUri, headers: {
      'Authorization': 'Bearer $token',
      'Accept-Language': 'de-DE',
      'Accept': 'application/json, text/plain, */*'
    });

    if (recipeResponse.statusCode != 200) {
      throw 'Error contacting $recipeUri';
    }

    return await _createRecipeFromJson(recipeResponse);
  }

  Future<MutableRecipe> _createRecipeFromJson(
      http.Response recipeResponse) async {
    // decode the JSON
    var recipeJson = jsonDecode(recipeResponse.body);
    // retrieve general information
    var recipeVariant = recipeJson['variants'][0];
    var basics = recipeVariant['basics'];
    var difficultyRawValue = basics['complexity'].toString().toLowerCase();
    var difficulty = _parseDifficulty(difficultyRawValue, recipeVariant);
    // duration is given in seconds
    var totalTime = basics['totalTime'];
    int duration = totalTime as int > 60 ? (totalTime ~/ 60) : 25;

    var recipe = Recipe(
      name: recipeJson['recipe']['title'],
      shortDescription: recipeVariant['summary'],
      diff: difficulty,
      servings: basics['numberOfServings'],
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

    // uom's from home connect do not use any standard IDs but string literals,
    // map these to cookza units
    final uomProvider = sl.get<UnitOfMeasureProvider>();
    final uoms = uomProvider.getAll();
    final pieceUom = uomProvider.getUnitOfMeasureById('H87');
    final unitMap = {
      'liquidVolume': uomProvider.getUnitOfMeasureById('MLT'),
      'weight': uomProvider.getUnitOfMeasureById('GRM'),
      'stalk': uomProvider.getUnitOfMeasureById('STE'),
      'teaspoon': uomProvider.getUnitOfMeasureById('G25'),
      'tablespoon': uomProvider.getUnitOfMeasureById('G24'),
      'pinch': uomProvider.getUnitOfMeasureById('PIN'),
      'piece': pieceUom,
      'leaf': uomProvider.getUnitOfMeasureById('LEF'),
      // use piece by default if no unit is given
      '': pieceUom,
    };

    // create instructions
    var instructions = recipeVariant['steps'];
    List<InstructionEntity> instructionEntities = [];
    for (var instruction in instructions) {
      var text = instruction['description'];
      var altText = instruction['alternativeSettingText'] ?? '';
      var mutableInstruction =
          MutableInstruction.withValues(text: '$text $altText'.trimRight());
      instructionEntities.add(mutableInstruction);
    }
    result.instructionList = instructionEntities;

    // create ingredients
    var groupCounter = 0;
    final ingGroupList = <IngredientGroupEntity>[];
    var ingGroups = recipeVariant['ingredientLists'];
    // process ingredient groups
    for (var group in ingGroups) {
      var groupName = group['name']?.toString().trim();
      groupName = (groupName == null || groupName.isEmpty)
          ? 'Group $groupCounter'
          : groupName;
      final groupIngredients = <MutableIngredientNote>[];

      // process every ingredient of the ingredient group
      for (var ingredient in group['ingredients']) {
        var description = ingredient['description'];
        var info = ingredient['info'];
        description = info != null ? '$description ($info)' : description;

        // retrieve amount and unit
        var amount = double.tryParse(ingredient['amount']) ?? 0;
        String? apiUnit = ingredient['unit'];
        UnitOfMeasure? uom = unitMap[apiUnit ?? ''];
        // amount and unit may not be present as a field
        // they may also be encoded in the ingredient description
        var firstMatch = amountAndUnitRegex.firstMatch(description);

        // if explicit amount is given it won't be zero
        if (firstMatch != null && amount == 0) {
          amount = double.parse(firstMatch.group(1) ?? '0');
        }

        // if explicit unit is given it won't be empty (default to piece)
        if (firstMatch != null && apiUnit == null) {
          apiUnit = firstMatch.group(2) ?? '';
          uom = uoms.firstWhereOrNull(
              (e) => e.displayName.toLowerCase() == apiUnit?.toLowerCase());
        }

        final finalAmount = amount > 0 ? amount : null;
        final finalUnit = finalAmount == null
            ? ''
            : uom != null
                ? uom.id
                : pieceUom.id;

        final note = MutableIngredientNote.of(
          IngredientNoteEntityJson.of(
            IngredientNote(
              amount: finalAmount,
              unitOfMeasure: finalUnit,
              ingredient: Ingredient(name: description),
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

  DIFFICULTY _parseDifficulty(String hcDiff, recipeVariant) {
    var difficulty = hcDiff == 'medium'
        ? DIFFICULTY.MEDIUM
        : recipeVariant == 'easy'
            ? DIFFICULTY.EASY
            : DIFFICULTY.HARD;
    return difficulty;
  }
}
