import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';

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
      var recipe = recipes.firstWhere((element) => element.id == entry.key,
          orElse: null);
      for (var note in await recipe.ingredients) {
        // check if ingredient already exists

        var baseServings = recipe.servings;
        var ratio = entry.value / baseServings;

        // TODO: don't work on the original instance == will be reused!!!
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

        var uomProvider = sl.get<UnitOfMeasureProvider>();
        // if it has a different uom
        for (var sameIngredientDiffUoM in sameIngredient) {
          // TODO handle differently
          if (sameIngredientDiffUoM.unitOfMeasure.isEmpty) {
            continue;
          }
          var targetUoM = uomProvider
              .getUnitOfMeasureById(sameIngredientDiffUoM.unitOfMeasure);

          var sourceUoM = uomProvider.getUnitOfMeasureById(note.unitOfMeasure);

          var convertable = sourceUoM.canBeConvertedTo(targetUoM);

          // if it can be converted, convert it
          if (convertable) {
            AmountedUnitOfMeasure amountedUoM =
                AmountedUnitOfMeasure(targetUoM, sameIngredientDiffUoM.amount);
            AmountedUnitOfMeasure sourceAmountedUoM =
                AmountedUnitOfMeasure(sourceUoM, note.amount * ratio);

            var calcResult = amountedUoM.add(sourceAmountedUoM);
            sameIngredientDiffUoM.amount = calcResult.amount;
            sameIngredientDiffUoM.unitOfMeasure = calcResult.uom.id;
            break;
          }
        }
      }
    }

    return result;
  }
}
