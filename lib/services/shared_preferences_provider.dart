import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesProvider {
  Future<SharedPreferencesProvider> init();

  SharedPreferences get instance;

  String? get theme;
  void setTheme(String value);

  bool isUnitOfMeasureVisible(String uom);
  void setUnitOfMeasureVisibility(String uom, bool visibility);
  void setMealPlanStandardServingsSize(int value);
  int getMealPlanStandardServingsSize();
  void setMealPlanWeeks(int weeks);
  int getMealPlanWeeks();
  String getUserName();
  void setUserName(String value);

  void setCurrentMealPlanCollection(String value);
  String? getCurrentMealPlanCollection();

  bool introductionShown();
  void setIntroductionShown(bool value);

  bool acceptedDataPrivacyStatement();
  void setAcceptedDataPrivacyStatement(bool value);

  bool acceptedTermsOfUse();
  void setAcceptedTermsOfUse(bool value);

  bool get showShoppingListCategories;
  set showShoppingListCategories(bool value);

  String? getLeastRecentlyUsedRecipeGroup();
  set leastRecentlyUsedRecipeGroup(String value);

  int getNewRecipeServingsSize();
  set newRecipeServingsSize(int servings);
}

class SharedPreferencesProviderImpl implements SharedPreferencesProvider {
  late SharedPreferences _prefs;

  static const String themeKey = 'theme';

  static const String showShoppingListCategoriesKey =
      'showShoppingListCategories';

  static const String mealPlanServingsSizeKey = 'mealPlanServingsSize';
  static const String mealPlanWeeksKey = 'mealPlanWeeks';
  static const String mealPlanCollection = 'mealPlanCollection';

  static const String uomVisibilityKeySuffix = '.vis';
  static const String userName = 'userName';

  static const String introductionShownKey = 'introShown';
  static const String acceptedDataPrivacyStatementKey =
      'privacyStatementAccepted';
  static const String acceptedTermsOfUseKey = 'termsOfUseAccepted';

  static const String leastRecentlyUsedRecipeGroupKey = 'lruRecipeGroup';

  static const String newRecipeServingsSizeKey = 'newRecipeServingsSize';
  static const String newRecipeDurationKey = 'newRecipeDuration';
  static const String newRecipeDifficultyKey = 'newRecipeDifficulty';

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
    assert(result > 0 && result < 11);
    return result;
  }

  @override
  bool isUnitOfMeasureVisible(String uom) {
    bool? result = _prefs.getBool(getUomVisibilityKey(uom));
    return result ?? true;
  }

  @override
  void setMealPlanStandardServingsSize(int value) {
    this._prefs.setInt(mealPlanServingsSizeKey, value);
  }

  @override
  void setMealPlanWeeks(int weeks) {
    assert(weeks > 0 && weeks < 11);
    this._prefs.setInt(mealPlanWeeksKey, weeks);
  }

  @override
  void setUnitOfMeasureVisibility(String uom, bool visibility) {
    _prefs.setBool(getUomVisibilityKey(uom), visibility);
  }

  @override
  String getUserName() {
    var result = _prefs.getString(userName);
    return result ?? '';
  }

  @override
  void setUserName(String value) {
    this._prefs.setString(userName, value);
  }

  @override
  String? getCurrentMealPlanCollection() {
    return _prefs.getString(mealPlanCollection);
  }

  @override
  void setCurrentMealPlanCollection(String value) {
    this._prefs.setString(mealPlanCollection, value);
  }

  @override
  bool introductionShown() {
    var result = _prefs.getBool(introductionShownKey);
    return result ?? false;
  }

  @override
  void setIntroductionShown(bool value) {
    this._prefs.setBool(introductionShownKey, value);
  }

  @override
  bool acceptedDataPrivacyStatement() {
    var result = _prefs.getBool(acceptedDataPrivacyStatementKey);
    return result ?? false;
  }

  @override
  void setAcceptedDataPrivacyStatement(bool value) {
    this._prefs.setBool(acceptedDataPrivacyStatementKey, value);
  }

  @override
  bool acceptedTermsOfUse() {
    var result = _prefs.getBool(acceptedTermsOfUseKey);
    return result ?? false;
  }

  @override
  void setAcceptedTermsOfUse(bool value) {
    this._prefs.setBool(acceptedTermsOfUseKey, value);
  }

  @override
  bool get showShoppingListCategories {
    var result = _prefs.getBool(showShoppingListCategoriesKey);
    return result ?? false;
  }

  @override
  set showShoppingListCategories(bool value) {
    this._prefs.setBool(showShoppingListCategoriesKey, value);
  }

  @override
  String? getLeastRecentlyUsedRecipeGroup() {
    return _prefs.getString(leastRecentlyUsedRecipeGroupKey);
  }

  @override
  set leastRecentlyUsedRecipeGroup(String value) {
    this._prefs.setString(leastRecentlyUsedRecipeGroupKey, value);
  }

  @override
  void setTheme(String value) {
    this._prefs.setString(themeKey, value);
  }

  @override
  String? get theme {
    return this._prefs.getString(themeKey);
  }

  @override
  int getNewRecipeServingsSize() {
    var value = this._prefs.getInt(newRecipeServingsSizeKey);
    if (value == null || value == 0) {
      value = 2;
    }
    return value;
  }

  @override
  set newRecipeServingsSize(int servings) =>
      this._prefs.setInt(newRecipeServingsSizeKey, servings);
}
