import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ThemeModelData {
  final String _key;

  ThemeModelData(this._key);

  String get displayName => translate('theme.$_key');
  String get key => _key;
}

class ThemeModel with ChangeNotifier {
  ThemeData _currentTheme;

  ThemeModel() {
    String theme =
        sl.get<SharedPreferencesProvider>().instance.getString('theme');
    if (theme != null && kAllThemes.containsKey(theme)) {
      _currentTheme = kAllThemes[theme];
    } else {
      _currentTheme = kDarkTheme;
    }
  }

  int get countThemes => kAllThemes.entries.length;

  bool isActive(String key) => _currentTheme == kAllThemes[key];

  List<ThemeModelData> getAvailableThemes() {
    return kAllThemes.entries
        .map((e) => ThemeModelData(e.key.toString()))
        .toList();
  }

  ThemeData get current => _currentTheme;

  Color get tileAccentColor {
//    if (_currentTheme == kDarkTheme) {
    return Color(0xFF021B2E);
    //  }
    // return Colors.blue.shade300;
  }

  String getCurrentThemeKey() {
    var theme = kAllThemes.entries
        .firstWhere((e) => e.value == _currentTheme, orElse: () => null);
    if (theme != null) {
      return theme.key;
    }
    return '';
  }

  set theme(String key) {
    var themeData = kAllThemes[key];
    this._currentTheme = themeData;
    notifyListeners();
  }
}
