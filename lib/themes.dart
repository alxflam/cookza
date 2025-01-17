import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final kAllThemes = {
  'dark': DarkTheme.create(),
  'light': LightTheme.create(),
};

abstract class CustomTheme {
  ThemeData get themeData;

  String get id;

  String get displayName;
}

final kBrightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorSchemeGen);

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

final kDarkTheme =
    ThemeData(useMaterial3: true, colorScheme: darkColorSchemeGen);

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

const lightColorSchemeGen = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006970),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF7CF4FF),
  onPrimaryContainer: Color(0xFF002022),
  secondary: Color(0xFF4A6365),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCCE8EA),
  onSecondaryContainer: Color(0xFF051F21),
  tertiary: Color(0xFF4F5F7D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD7E2FF),
  onTertiaryContainer: Color(0xFF0A1B36),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFAFDFC),
  onSurface: Color(0xFF191C1D),
  surfaceContainerHighest: Color(0xFFDAE4E5),
  onSurfaceVariant: Color(0xFF3F4849),
  outline: Color(0xFF6F797A),
  onInverseSurface: Color(0xFFEFF1F1),
  inverseSurface: Color(0xFF2D3131),
  inversePrimary: Color(0xFF4DD9E4),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006970),
  outlineVariant: Color(0xFFBEC8C9),
  scrim: Color(0xFF000000),
);

const darkColorSchemeGen = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF4DD9E4),
  onPrimary: Color(0xFF00363A),
  primaryContainer: Color(0xFF004F54),
  onPrimaryContainer: Color(0xFF7CF4FF),
  secondary: Color(0xFFB1CBCE),
  onSecondary: Color(0xFF1B3437),
  secondaryContainer: Color(0xFF324B4D),
  onSecondaryContainer: Color(0xFFCCE8EA),
  tertiary: Color(0xFFB7C7EA),
  onTertiary: Color(0xFF21304C),
  tertiaryContainer: Color(0xFF384764),
  onTertiaryContainer: Color(0xFFD7E2FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF191C1D),
  onSurface: Color(0xFFE0E3E3),
  surfaceContainerHighest: Color(0xFF3F4849),
  onSurfaceVariant: Color(0xFFBEC8C9),
  outline: Color(0xFF899393),
  onInverseSurface: Color(0xFF191C1D),
  inverseSurface: Color(0xFFE0E3E3),
  inversePrimary: Color(0xFF006970),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF4DD9E4),
  outlineVariant: Color(0xFF3F4849),
  scrim: Color(0xFF000000),
);
