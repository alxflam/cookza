import 'package:cookza/services/image_parser.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/unit_of_measure_provider_mock.dart';

class VisionTextFake extends Fake implements RecognizedText {
  final String _text;
  final List<TextBlock> _blocks;

  VisionTextFake(this._text, this._blocks);

  @override
  String get text => this._text;

  @override
  List<TextBlock> get blocks => this._blocks;
}

class TextBlockMock extends Mock implements TextBlock {}

class TextLineMock extends Mock implements TextLine {}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I
        .registerSingleton<UnitOfMeasureProvider>(UnitOfMeasureProviderMock());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test(
    'Parse overview',
    () {
      var cut = ImageTextExtractorImpl();
      var mock = VisionTextFake('', []);

      var ov = cut.processOverviewImageFromText(mock);
      expect(ov, isNotNull);

      var ing = cut.processIngredientsImageFromText(mock);
      expect(ing, isNotNull);

      var ins = cut.processInstructionsImageFromText(mock);
      expect(ins, isNotNull);
    },
  );
}
