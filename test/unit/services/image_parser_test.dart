import 'package:cookly/services/image_parser.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/unit_of_measure_provider_mock.dart';

void main() {
  setUpAll(() {
    GetIt.I
        .registerSingleton<UnitOfMeasureProvider>(UnitOfMeasureProviderMock());
  });
  test(
    'Parse overview',
    () {
      var cut = ImageTextExtractorImpl();

      // var text = VisionText();

      // cut.processOverviewImageFromText(text);
    },
  );
}
