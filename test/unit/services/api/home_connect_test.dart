import 'package:cookza/services/api/home_connect.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mocks/uom_provider_mock.dart';

void main() {
  final sl = GetIt.instance;
  sl.registerSingleton<UnitOfMeasureProvider>(UoMMock());
  var cut = HomeConnectImporterImpl();

  test('test non-Cookit recipe', () async {
    var url =
        'https://home-connect.recipes/vu9iwvaw/risotto-ai-funghi---mushroom-risotto';

    final result = await cut.getRecipe(url);

    expect(result.name, 'Risotto ai funghi - Pilzrisotto');
  }, skip: true);

  test('test Cookit recipe', () async {
    var url = 'https://home-connect.recipes/49cy6tht/erbsen-minz-risotto';
    // var url =
    //     'https://home-connect.recipes/sigm4yir/warmer-feta-mit-hirtensalat';
    // var url =
    //     'https://home-connect.recipes/kx8e6eio/cremiges-putengyros-mit-champignons';
    // var url =
    //     'https://home-connect.recipes/42rh28qd/sommerrollen-mit-erdnusssauce';
    // var url =
    //     'https://home-connect.recipes/yn7xgi3r/auberginen-lachs-rollchen-mit-sauce-vierge';

    final result = await cut.getRecipe(url);

    expect(result.name, 'Erbsen-Minz-Risotto');
  }, skip: true);
}
