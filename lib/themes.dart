import 'package:flutter/material.dart';

final kAllThemes = {
  'dark': DarkTheme.create(),
  'light': LightTheme.create(),
};

const kAppIconColor = Color(0xFF021B2E);

abstract class CustomTheme {
  ThemeData get themeData;

  Color get appIconColor;

  String get id;
}

final kDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    color: kAppIconColor,
  ),
);

class DarkTheme extends CustomTheme {
  final ThemeData _themeData;

  factory DarkTheme.create() {
    return DarkTheme(kDarkTheme);
  }

  DarkTheme(this._themeData);

  @override
  Color get appIconColor => kAppIconColor;

  @override
  ThemeData get themeData => this._themeData;

  @override
  String get id => 'dark';
}

final kLightTheme = ThemeData.light().copyWith();

class LightTheme extends CustomTheme {
  final ThemeData _themeData;

  factory LightTheme.create() {
    return LightTheme(kLightTheme);
  }

  LightTheme(this._themeData);

  @override
  Color get appIconColor => this._themeData.primaryColor;

  @override
  ThemeData get themeData => this._themeData;

  @override
  String get id => 'light';
}
