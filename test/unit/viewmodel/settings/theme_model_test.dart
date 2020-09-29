import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('Default theme', () async {
    var cut = ThemeModel();
    expect(cut.current, isNotNull);
    expect(cut.getCurrentThemeKey(), 'dark');
    var isActive = cut.isActive('dark');
    expect(isActive, true);
  });

  test('IsActive', () async {
    var cut = ThemeModel();
    expect(cut.getCurrentThemeKey(), 'dark');
    expect(cut.isActive('dark'), true);
    expect(cut.isActive('light'), false);
  });

  test('Available themes', () async {
    var cut = ThemeModel();
    expect(cut.getAvailableThemes().length, 2);
    expect(cut.countThemes, 2);
  });

  test('Tile Accent Color', () async {
    var cut = ThemeModel();
    expect(cut.tileAccentColor, isNotNull);
  });

  test('Change theme', () async {
    var cut = ThemeModel();
    cut.theme = 'light';
    expect(cut.isActive('dark'), false);
    expect(cut.isActive('light'), true);
  });
}
