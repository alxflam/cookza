import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final kAllThemes = {
  'dark': DarkTheme.create(),
  'light': LightTheme.create(),
  'bright': BrightTheme.create(),
};

/// dark theme app icon color
const kBlueAppIconColor = Color(0xFF021B2E);

abstract class CustomTheme {
  ThemeData get themeData;

  String get id;

  String get displayName;
}

final kBrightColorScheme =
    ColorScheme.light().copyWith(primary: kBlueAppIconColor);

// final kTextTheme = ThemeData(brightness: Brightness.light).textTheme.copyWith();
final kBrightTheme = ThemeData.from(colorScheme: kBrightColorScheme).copyWith(
    cardColor: Colors.grey.shade300,
    appBarTheme: AppBarTheme(color: kBlueAppIconColor));

class BrightTheme extends CustomTheme {
  factory BrightTheme.create() {
    return BrightTheme();
  }

  BrightTheme();

  @override
  ThemeData get themeData => kBrightTheme;

  @override
  String get id => 'bright';

  @override
  String get displayName {
    return 'bright';
  }
}

final kDarkColorScheme = ColorScheme.dark().copyWith(
    background: Color(0xFF121212),
    primary: Colors.greenAccent.shade100,
    primaryVariant: Colors.greenAccent.shade400);

final kDarkTheme = ThemeData.from(colorScheme: kDarkColorScheme).copyWith(
    cardColor: Colors.grey.shade900,
    accentColor: kDarkColorScheme.primary,
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade900,
    ));

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
    return AppLocalizations.of(context).themeDark;
  }
}

final kLightTheme = ThemeData.light().copyWith();

class LightTheme extends CustomTheme {
  factory LightTheme.create() {
    return LightTheme();
  }

  LightTheme();

  @override
  ThemeData get themeData => kLightTheme;

  @override
  String get id => 'light';

  @override
  String get displayName {
    var context = sl.get<NavigatorService>().currentContext;
    return AppLocalizations.of(context).themeLight;
  }
}
