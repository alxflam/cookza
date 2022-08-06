import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';

class NewRecipeSettingsModel with ChangeNotifier {
  final SharedPreferencesProvider _prefs = sl.get<SharedPreferencesProvider>();

  NewRecipeSettingsModel.create();

  int get defaultServingsSize => this._prefs.getNewRecipeServingsSize();

  set defaultServingsSize(int value) {
    this._prefs.newRecipeServingsSize = value;
    notifyListeners();
  }
}
