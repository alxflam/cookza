import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';

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
      var recipe =
          recipes.firstWhere((e) => e.id == entry.key, orElse: () => null);
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

    for (var note in await recipe.ingredients) {
      var ratio = entry.value / baseServings;

      // if a recipe reference is given, resolve it's ingredients
      if (note.ingredient.isRecipeReference) {
        // read the recipe
        var targetRecipe = await sl
            .get<RecipeManager>()
            .getRecipeById([note.ingredient.recipeReference]);
        if (targetRecipe.length == 1) {
          var ing = await targetRecipe.first.ingredients;
          var circularDependency = ing.firstWhere(
              (e) => e.ingredient.recipeReference == recipe.id,
              orElse: () => null);
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
        var amount = note.amount * ratio;
        targetNote.amount = amount;
        result.add(targetNote);
        continue;
      }

      // else if it exists with same uom, add the new amount
      var sameUoM = sameIngredient.firstWhere(
          (e) => e.unitOfMeasure == note.unitOfMeasure,
          orElse: () => null);
      if (sameUoM != null) {
        sameUoM.amount = sameUoM.amount + note.amount * ratio;
        continue;
      }

      // if it has a different uom
      var uomProvider = sl.get<UnitOfMeasureProvider>();
      bool updated = _convertUnit(sameIngredient, uomProvider, note, ratio);
      if (!updated) {
        // if the unit could not be coonverted, add the ingredient
        var targetNote = MutableIngredientNote.of(note);
        var amount = note.amount * ratio;
        targetNote.amount = amount;
        result.add(targetNote);
      }
    }
  }

  bool _convertUnit(
      List<MutableIngredientNote> sameIngredient,
      UnitOfMeasureProvider uomProvider,
      IngredientNoteEntity note,
      double ratio) {
    for (var sameIngredientDiffUoM in sameIngredient) {
      if (sameIngredientDiffUoM.unitOfMeasure.isEmpty) {
        continue;
      }
      var targetUoM =
          uomProvider.getUnitOfMeasureById(sameIngredientDiffUoM.unitOfMeasure);

      var sourceUoM = uomProvider.getUnitOfMeasureById(note.unitOfMeasure);

      var convertable = sourceUoM?.canBeConvertedTo(targetUoM) ?? false;

      // if it can be converted, convert it
      if (convertable) {
        AmountedUnitOfMeasure amountedUoM =
            AmountedUnitOfMeasure(targetUoM, sameIngredientDiffUoM.amount);
        AmountedUnitOfMeasure sourceAmountedUoM =
            AmountedUnitOfMeasure(sourceUoM, note.amount * ratio);

        var calcResult = amountedUoM.add(sourceAmountedUoM);
        sameIngredientDiffUoM.amount = calcResult.amount;
        sameIngredientDiffUoM.unitOfMeasure = calcResult.uom.id;
        return true;
      }
    }
    return false;
  }
}
