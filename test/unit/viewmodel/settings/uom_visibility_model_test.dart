import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/settings/uom_visibility_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  var uomProvider = StaticUnitOfMeasure();
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(uomProvider);
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('change visibility', () async {
    var cut = UoMVisibilitySettingsModel.create();
    var uom = uomProvider.getUnitOfMeasureById('GRM');
    expect(cut.isVisible(uom), true);
    cut.setVisible(uom, false);
    expect(cut.isVisible(uom), false);
    cut.setVisible(uom, true);
    expect(cut.isVisible(uom), true);
  });

  test('All UoM are included', () async {
    var cut = UoMVisibilitySettingsModel.create();
    expect(cut.countAll, 38);
  });

  test('Get UoM by index', () async {
    var cut = UoMVisibilitySettingsModel.create();
    expect(cut.getByIndex(0).id, 'MMT');
  });
}
