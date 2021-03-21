import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/themes.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ThemeModelData {
  final CustomTheme _theme;

  ThemeModelData(this._theme);

  String get displayName => _theme.displayName;
  String get key => this._theme.id;
}

class ThemeModel with ChangeNotifier {
  late CustomTheme _currentTheme;

  ThemeModel() {
    final theme = sl.get<SharedPreferencesProvider>().theme;
    if (theme != null && kAllThemes.containsKey(theme)) {
      _currentTheme = kAllThemes[theme]!;
    } else {
      _currentTheme = kAllThemes['dark']!;
    }
  }

  int get countThemes => kAllThemes.entries.length;

  bool isActive(String key) {
    var theme = kAllThemes[key];
    return _currentTheme == theme;
  }

  List<ThemeModelData> getAvailableThemes() {
    return kAllThemes.entries.map((e) => ThemeModelData(e.value)).toList();
  }

  ThemeData get current => _currentTheme.themeData;

  String getCurrentThemeKey() {
    var theme =
        kAllThemes.entries.firstWhereOrNull((e) => e.key == _currentTheme.id);
    if (theme != null) {
      return theme.key;
    }
    return '';
  }

  set theme(String key) {
    if (kAllThemes.containsKey(key)) {
      var themeData = kAllThemes[key]!;
      this._currentTheme = themeData;
      sl.get<SharedPreferencesProvider>().setTheme(key);
      notifyListeners();
    }
  }
}
