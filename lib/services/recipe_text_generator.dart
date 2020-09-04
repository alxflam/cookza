import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class RecipeTextGenerator {
  Future<String> generateRecipeText(List<RecipeEntity> entities);
}

class RecipeTextGeneratorImpl implements RecipeTextGenerator {
  var uomProvider = sl.get<UnitOfMeasureProvider>();

  @override
  Future<String> generateRecipeText(List<RecipeEntity> entities) async {
    var buffer = new StringBuffer();

    for (var entity in entities) {
      buffer.write('*');
      buffer.write(entity.name);
      buffer.write('*');
      buffer.writeln();
      if (entity.description.isNotEmpty) {
        buffer.writeln(entity.description);
      }

      buffer.writeln();
      buffer.write('*');
      buffer.write(translatePlural(Keys.Recipe_Ingredient, 2));
      buffer.write('*');
      buffer.writeln();
      for (var ingredient in await entity.ingredients) {
        buffer.write(kBulletCharacter);
        buffer.write(' ');
        buffer.write(ingredient.ingredient.name);
        buffer.write(' ');

        if (ingredient.amount != null && ingredient.amount > 0) {
          buffer.write('(');
          buffer.write(kFormatAmount(ingredient.amount));

          if (ingredient.unitOfMeasure != null) {
            buffer.write(' '); // space between amount and unit
            var uom =
                uomProvider.getUnitOfMeasureById(ingredient.unitOfMeasure);
            buffer.write(uom != null ? uom.displayName : '');
          }
          buffer.write(')');
        }

        buffer.writeln();
      }

      buffer.writeln();
      buffer.write('*');
      buffer.write(translate(Keys.Recipe_Instructions));
      buffer.write('*');
      buffer.writeln();
      var counter = 1;
      for (var instruction in await entity.instructions) {
        buffer.write(counter);
        buffer.write('. ');
        buffer.write(instruction.text);
        buffer.writeln();
        counter++;
      }
    }

    return buffer.toString();
  }
}
