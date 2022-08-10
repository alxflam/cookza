import 'package:cookza/services/api/chefkoch.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mocks/uom_provider_mock.dart';

void main() {
  test(
    'Read Recipe',
    () async {
      final sl = GetIt.instance;

      sl.registerSingleton<UnitOfMeasureProvider>(UoMMock());

      var id = '922651197624364';
      var url = 'https://www.chefkoch.de/rezepte/$id/xyz';

      var cut = ChefkochImporterImpl();

      final result = await cut.getRecipe(url);

      expect(result.name, 'Philadelphia-Hähnchen');
      var ins = await result.instructions;
      expect(ins.length, 5);
      var group = await result.ingredientGroups;
      expect(group.length, 1);
      expect(group.first.ingredients.length, 9);
    },
  );
}
