import 'package:cookly/services/api/chefkoch.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mocks/uom_mock.dart';

void main() {
  test(
    'Read Recipe',
    () async {
      final sl = GetIt.instance;

      sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
      sl.registerSingleton<UnitOfMeasureProvider>(UoMMock());

      var id = '922651197624364';

      var cut = Chefkoch();

      var result = await cut.getRecipe(id);

      expect(result.name, 'Philadelphia-Hähnchen');
      expect(result.rating, 4);
      var ins = await result.instructions;
      expect(ins.length, 9);
      var ing = await result.ingredients;
      expect(ing.length, 9);
    },
  );
}