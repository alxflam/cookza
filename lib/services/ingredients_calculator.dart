import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';

abstract class IngredientsCalculator {
  Future<List<IngredientNote>> getIngredients(Map<String, int> ids);
}

class IngredientsCalculatorImpl implements IngredientsCalculator {
  @override
  Future<List<IngredientNote>> getIngredients(Map<String, int> ids) async {
    List<IngredientNote> result = [];

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

        // if it does not, directly add it
        if (sameIngredient.isEmpty) {
          var amount = note.amount * ratio;
          var newNote = IngredientNote.fromEntity(note);
          newNote.amount = amount;
          result.add(newNote);
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
            result.remove(sameIngredientDiffUoM);
            result.add(
              IngredientNote(
                  amount: calcResult.amount,
                  unitOfMeasure: calcResult.uom.id,
                  ingredient: sameIngredientDiffUoM.ingredient),
            );
            break;
          }
        }

        // else add as new entry

      }
    }

    return result;
  }
}
