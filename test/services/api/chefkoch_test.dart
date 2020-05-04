import 'package:cookly/services/api/chefkoch.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test(
    'Read Recipe',
    () async {
      final sl = GetIt.instance;

      sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());

      var id = '922651197624364';

      var cut = Chefkoch();

      var result = await cut.getRecipe(id);

      expect(result.name, 'Philadelphia-Hähnchen');
      expect(result.rating, 4);
      expect(result.instructions, 5);
      expect(result.ingredients, 9);
    },
  );
}
