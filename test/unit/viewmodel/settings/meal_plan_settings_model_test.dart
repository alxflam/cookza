import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/settings/meal_plan_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('Change servings size', () async {
    var cut = MealPlanSettingsModel.create();

    cut.setStandardServingsSize(5);
    expect(cut.standardServingsSize, 5);
  });

  test('Change meal plan weeks', () async {
    var cut = MealPlanSettingsModel.create();

    cut.setWeeks(3);
    expect(cut.weeks, 3);
  });
}
