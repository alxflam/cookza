import 'package:cookly/services/api/hello_fresh.dart';
import 'package:cookly/services/util/id_gen.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mocks/uom_provider_mock.dart';

void main() {
  test(
    'Read Recipe',
    () async {
      final sl = GetIt.instance;

      sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
      sl.registerSingleton<UnitOfMeasureProvider>(UoMMock());

      // var id = '5f2ac031226ba26eee2f9574';

      var cut = HelloFresh();
      expect(cut, isNotNull);

      // var result = await cut.getRecipe(id);

      // expect(result.name, 'Rauchige Süßkartoffel-Hirtenkäse-Tacos');
      // expect(result.description, 'mit selbstgemachter Salsa und Srirachadip');
      // var ins = await result.instructions;
      // expect(ins.length, 9);
      // var ing = await result.ingredients;
      // expect(ing.length, 9);
    },
  );
}
