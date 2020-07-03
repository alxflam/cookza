import 'package:flutter/material.dart';

final kAllThemes = {
  'dark': kDarkTheme,
  'light': kLightTheme,
};

final kDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade900,
);
final kLightTheme = ThemeData.light().copyWith();
