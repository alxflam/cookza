import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:collection/collection.dart';

abstract class IngredientsCalculator {
  Future<List<IngredientNoteEntity>> getIngredients(Map<String, int> ids);
}

class IngredientsCalculatorImpl implements IngredientsCalculator {
  @override
  Future<List<IngredientNoteEntity>> getIngredients(
      Map<String, int> ids) async {
    List<MutableIngredientNote> result = [];

    if (ids.isEmpty) {
      return result;
    }

    var recipes =
        await sl.get<RecipeManager>().getRecipeById(ids.keys.toList());

    for (var entry in ids.entries) {
      var recipe = recipes.firstWhereOrNull((e) => e.id == entry.key);
      if (recipe == null) {
        continue;
      }

      await _processRecipe(recipe, entry, result);
    }

    return result;
  }

  Future _processRecipe(RecipeEntity recipe, MapEntry<String, int> entry,
      List<MutableIngredientNote> result) async {
    var baseServings = recipe.servings;

    for (var group in await recipe.ingredientGroups) {
      for (var note in group.ingredients) {
        var ratio = entry.value / baseServings;

        // if a recipe reference is given, resolve it's ingredients
        if (note.ingredient.isRecipeReference) {
          // read the recipe
          var targetRecipe = await sl
              .get<RecipeManager>()
              .getRecipeById([note.ingredient.recipeReference!]);
          if (targetRecipe.length == 1) {
            var ing = (await targetRecipe.first.ingredientGroups)
                .map((e) => e.ingredients)
                .expand((e) => e)
                .toSet();
            var circularDependency = ing.firstWhereOrNull(
                (e) => e.ingredient.recipeReference == recipe.id);
            if (circularDependency == null) {
              //recurse
              await _processRecipe(targetRecipe.first, entry, result);
            }
          }
          // and don't process the recipe reference itself as an ingredient
          continue;
        }

        // check if ingredient already exists
        var sameIngredient = result
            .where((e) => e.ingredient.name == note.ingredient.name)
            .toList();

        // if it does not exist yet, directly add it
        if (sameIngredient.isEmpty) {
          var targetNote = MutableIngredientNote.of(note);
          var amount = (note.amount ?? 1) * ratio;
          targetNote.amount = amount;
          result.add(targetNote);
          continue;
        }

        // else if it exists with same uom, add the new amount
        var sameUoM = sameIngredient
            .firstWhereOrNull((e) => e.unitOfMeasure == note.unitOfMeasure);
        if (sameUoM != null) {
          sameUoM.amount = (sameUoM.amount ?? 1) + (note.amount ?? 1) * ratio;
          continue;
        }

        // if it has a different uom
        var uomProvider = sl.get<UnitOfMeasureProvider>();
        bool updated = _convertUnit(sameIngredient, uomProvider, note, ratio);
        if (!updated) {
          // if the unit could not be converted, add the ingredient
          var targetNote = MutableIngredientNote.of(note);
          var amount = (note.amount ?? 1) * ratio;
          targetNote.amount = amount;
          result.add(targetNote);
        }
      }
    }
  }

  bool _convertUnit(
      List<MutableIngredientNote> sameIngredient,
      UnitOfMeasureProvider uomProvider,
      IngredientNoteEntity note,
      double ratio) {
    if (note.unitOfMeasure?.isEmpty ?? true) {
      return false;
    }

    for (var sameIngredientDiffUoM in sameIngredient) {
      if (sameIngredientDiffUoM.unitOfMeasure?.isEmpty ?? true) {
        continue;
      }

      var targetUoM = uomProvider
          .getUnitOfMeasureById(sameIngredientDiffUoM.unitOfMeasure!);
      var sourceUoM = uomProvider.getUnitOfMeasureById(note.unitOfMeasure!);
      var convertable = sourceUoM.canBeConvertedTo(targetUoM);

      // if it can be converted, convert it
      if (convertable) {
        AmountedUnitOfMeasure amountedUoM =
            AmountedUnitOfMeasure(targetUoM, sameIngredientDiffUoM.amount ?? 1);
        AmountedUnitOfMeasure sourceAmountedUoM =
            AmountedUnitOfMeasure(sourceUoM, (note.amount ?? 1) * ratio);

        var calcResult = amountedUoM.add(sourceAmountedUoM);
        sameIngredientDiffUoM.amount = calcResult.amount;
        sameIngredientDiffUoM.unitOfMeasure = calcResult.uom.id;
        return true;
      }
    }
    return false;
  }
}
