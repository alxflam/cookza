import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesProvider {
  Future<SharedPreferencesProvider> init();

  SharedPreferences get instance;

  bool isUnitOfMeasureVisible(String uom);
  void setUnitOfMeasureVisibility(String uom, bool visibility);
  void setMealPlanStandardServingsSize(int value);
  int getMealPlanStandardServingsSize();
  void setMealPlanWeeks(int weeks);
  int getMealPlanWeeks();
}

class SharedPreferencesProviderImpl implements SharedPreferencesProvider {
  SharedPreferences _prefs;

  static final String mealPlanServingsSizeKey = 'mealPlanServingsSize';
  static final String mealPlanWeeksKey = 'mealPlanWeeks';
  static final String uomVisibilityKeySuffix = '.vis';

  String getUomVisibilityKey(String uom) => '$uom$uomVisibilityKeySuffix';

  @override
  Future<SharedPreferencesProvider> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  @override
  SharedPreferences get instance => _prefs;

  @override
  int getMealPlanStandardServingsSize() {
    var value = this._prefs.getInt(mealPlanServingsSizeKey);
    if (value == null || value == 0) {
      value = 2;
    }
    return value;
  }

  @override
  int getMealPlanWeeks() {
    var result = this._prefs.getInt(mealPlanWeeksKey);
    if (result == null || result == 0) {
      result = 2;
    }
    assert(result > 0 && result < 3);
    return result;
  }

  @override
  bool isUnitOfMeasureVisible(String uom) {
    bool result = _prefs.getBool(getUomVisibilityKey(uom));
    return result == null ? true : result;
  }

  @override
  void setMealPlanStandardServingsSize(int value) {
    this._prefs.setInt(mealPlanServingsSizeKey, value);
  }

  @override
  void setMealPlanWeeks(int weeks) {
    assert(weeks > 0 && weeks < 3);
    this._prefs.setInt(mealPlanWeeksKey, weeks);
  }

  @override
  void setUnitOfMeasureVisibility(String uom, bool visibility) {
    _prefs.setBool(getUomVisibilityKey(uom), visibility);
  }
}
