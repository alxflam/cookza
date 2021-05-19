import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final kAllThemes = {
  'dark': DarkTheme.create(),
  'light': LightTheme.create(),
};

/// light theme app icon color
const kBlueAppIconColor = Color(0xFF021B2E);

abstract class CustomTheme {
  ThemeData get themeData;

  String get id;

  String get displayName;
}

final kBrightColorScheme = ColorScheme.light().copyWith(
  primary: kBlueAppIconColor,
);

final kBrightTheme = ThemeData.from(colorScheme: kBrightColorScheme).copyWith(
  cardColor: Colors.grey.shade300,
  accentColor: kBrightColorScheme.primary,
  appBarTheme: AppBarTheme(color: kBlueAppIconColor),
);

class LightTheme extends CustomTheme {
  factory LightTheme.create() {
    return LightTheme();
  }

  LightTheme();

  @override
  ThemeData get themeData => kBrightTheme;

  @override
  String get id => 'light';

  @override
  String get displayName {
    var context = sl.get<NavigatorService>().currentContext;
    return AppLocalizations.of(context!).themeLight;
  }
}

final kDarkColorScheme = ColorScheme.dark().copyWith(
  background: Color(0xFF121212),
  primary: Colors.tealAccent.shade700,
  primaryVariant: Colors.tealAccent.shade700,
);

final kDarkTheme = ThemeData.from(colorScheme: kDarkColorScheme).copyWith(
  cardColor: Colors.grey.shade900,
  accentColor: kDarkColorScheme.primary,
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade900,
  ),
);

class DarkTheme extends CustomTheme {
  factory DarkTheme.create() {
    return DarkTheme();
  }

  DarkTheme();

  @override
  ThemeData get themeData => kDarkTheme;

  @override
  String get id => 'dark';

  @override
  String get displayName {
    var context = sl.get<NavigatorService>().currentContext;
    return AppLocalizations.of(context!).themeDark;
  }
}
