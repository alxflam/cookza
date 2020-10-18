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
  String getUserName();
  void setUserName(String value);

  void setCurrentMealPlanCollection(String value);
  String getCurrentMealPlanCollection();

  bool introductionShown();
  void setIntroductionShown(bool value);

  bool acceptedDataPrivacyStatement();
  void setAcceptedDataPrivacyStatement(bool value);

  bool acceptedTermsOfUse();
  void setAcceptedTermsOfUse(bool value);

  bool get showShoppingListCategories;
  set showShoppingListCategories(bool value);

  String get leastRecentlyUsedRecipeGroup;
  set leastRecentlyUsedRecipeGroup(String value);
}

class SharedPreferencesProviderImpl implements SharedPreferencesProvider {
  SharedPreferences _prefs;

  static final String showShoppingListCategoriesKey =
      'showShoppingListCategories';

  static final String mealPlanServingsSizeKey = 'mealPlanServingsSize';
  static final String mealPlanWeeksKey = 'mealPlanWeeks';
  static final String mealPlanCollection = 'mealPlanCollection';

  static final String uomVisibilityKeySuffix = '.vis';
  static final String userName = 'userName';

  static final String introductionShownKey = 'introShown';
  static final String acceptedDataPrivacyStatementKey =
      'privacyStatementAccepted';
  static final String acceptedTermsOfUseKey = 'termsOfUseAccepted';

  static final String leastRecentlyUsedRecipeGroupKey = 'lruRecipeGroup';

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
    bool result = _prefs.getBool(getUomVisibilityKey(uom));
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
    assert(value != null);
    this._prefs.setString(userName, value);
  }

  @override
  String getCurrentMealPlanCollection() {
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
  String get leastRecentlyUsedRecipeGroup {
    return _prefs.getString(leastRecentlyUsedRecipeGroupKey);
  }

  @override
  set leastRecentlyUsedRecipeGroup(String value) {
    this._prefs.setString(leastRecentlyUsedRecipeGroupKey, value);
  }
}
