import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';

class ShoppingListSettingsModel with ChangeNotifier {
  final SharedPreferencesProvider _prefs = sl.get<SharedPreferencesProvider>();

  ShoppingListSettingsModel.create();

  bool get showCategories => this._prefs.showShoppingListCategories;

  set showCategories(bool value) {
    this._prefs.showShoppingListCategories = value;
    notifyListeners();
  }

  List<String> get categories => ['MoPro', 'Obst&Gemüse', 'Fisch&Fleisch'];
}
