import 'package:cookza/services/image_parser.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/unit_of_measure_provider_mock.dart';

class VisionTextMock extends Fake implements VisionText {
  final String _text;
  final List<TextBlock> _blocks;

  VisionTextMock(this._text, this._blocks);

  @override
  String? get text => this._text;

  @override
  List<TextBlock> get blocks => this._blocks;
}

class TextBlockMock extends Mock implements TextBlock {}

class TextLineMock extends Mock implements TextLine {}

void main() {
  setUpAll(() {
    GetIt.I
        .registerSingleton<UnitOfMeasureProvider>(UnitOfMeasureProviderMock());
  });

  test(
    'Parse overview',
    () {
      var cut = ImageTextExtractorImpl();
      var mock = VisionTextMock('', []);

      var result = cut.processOverviewImageFromText(mock);
      expect(result, isNotNull);
    },
  );
}
