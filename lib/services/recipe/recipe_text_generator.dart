import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';

abstract class RecipeTextGenerator {
  Future<String> generateRecipeText(List<RecipeEntity> entities,
      String ingredientsTitle, String instructionsTitle);
}

class RecipeTextGeneratorImpl implements RecipeTextGenerator {
  var uomProvider = sl.get<UnitOfMeasureProvider>();

  @override
  Future<String> generateRecipeText(List<RecipeEntity> entities,
      String ingredientsTitle, String instructionsTitle) async {
    var buffer = StringBuffer();

    for (var entity in entities) {
      buffer.write('*');
      buffer.write(entity.name);
      buffer.write('*');
      buffer.writeln();
      if (entity.description?.isNotEmpty ?? false) {
        buffer.writeln(entity.description);
      }

      buffer.writeln();
      buffer.write('*');
      buffer.write(ingredientsTitle);
      buffer.write('*');
      buffer.writeln();

      final groups = await entity.ingredientGroups;
      for (var group in groups) {
        if (groups.length > 1) {
          buffer.write('*');
          buffer.write(group.name);
          buffer.write('*');
          buffer.writeln();
        }
        for (var ingredient in group.ingredients) {
          buffer.write(kBulletCharacter);
          buffer.write(' ');
          buffer.write(ingredient.ingredient.name);
          buffer.write(' ');

          if ((ingredient.amount ?? 0) > 0) {
            buffer.write('(');
            buffer.write(kFormatAmount(ingredient.amount));

            if (ingredient.unitOfMeasure != null &&
                ingredient.unitOfMeasure!.isNotEmpty) {
              buffer.write(' '); // space between amount and unit
              var uom =
                  uomProvider.getUnitOfMeasureById(ingredient.unitOfMeasure!);
              buffer.write(uom.displayName);
            }
            buffer.write(')');
          }

          buffer.writeln();
        }
      }

      buffer.writeln();
      buffer.write('*');
      buffer.write(instructionsTitle);
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
