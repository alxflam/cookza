import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';

class MealPlanSettingsModel with ChangeNotifier {
  final SharedPreferencesProvider _prefs = sl.get<SharedPreferencesProvider>();

  MealPlanSettingsModel.create();

  int get weeks => this._prefs.getMealPlanWeeks();

  int get standardServingsSize => this._prefs.getMealPlanStandardServingsSize();

  void setStandardServingsSize(int value) {
    this._prefs.setMealPlanStandardServingsSize(value);
    notifyListeners();
  }

  void setWeeks(int weeks) {
    this._prefs.setMealPlanWeeks(weeks);
    notifyListeners();
  }
}
