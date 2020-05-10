import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MealDragModel {
  int _origin;
  String _id;

  String get id => _id;
  int get origin => _origin;

  MealDragModel(this._id, this._origin);
}

class MealPlanViewModel extends ChangeNotifier {
  List<MealPlanDateEntry> entries = [];
  Locale _locale;
  String _recipeIdForAddition;

  MealPlanViewModel(this._locale) {
    var now = DateTime.now().toLocal();
    for (var i = 0; i < 14; i++) {
      entries.add(
          MealPlanDateEntry(DateTime.now().add(Duration(days: i)), _locale));
    }
    print('locale is $_locale');
  }

  void moveRecipe(MealDragModel data, int target) {
    entries[data.origin].removeRecipe(data.id);
    entries[target].addRecipe(data.id);
    notifyListeners();
  }

  void removeRecipe(String id, int i) {
    entries[i].removeRecipe(id);
    notifyListeners();
  }

  void addRecipe(int index, String id) {
    entries[index].addRecipe(id);
    notifyListeners();
  }

  void setRecipeForAddition(String id) {
    _recipeIdForAddition = id;
  }

  void addByNavigation(int index) {
    addRecipe(index, _recipeIdForAddition);
    _recipeIdForAddition = null;
    notifyListeners();
  }

  bool get addByNavigationRequired =>
      _recipeIdForAddition != null && _recipeIdForAddition.isNotEmpty
          ? true
          : false;
}

class MealPlanDateEntry {
  DateTime _date;
  Map<String, String> _recipes = {};
  Locale _locale;

  MealPlanDateEntry(this._date, this._locale);

  void addRecipe(String id) {
    var name = sl.get<DataStore>().appProfile.getRecipeById(id)?.name;
    _recipes.putIfAbsent(id, () => name);
  }

  void removeRecipe(String id) {
    _recipes.remove(id);
  }

  String get header {
    var day = DateFormat.EEEE(this._locale.toString()).format(_date);
    var date = DateFormat('d.MM.yyyy').format(_date);
    return '$day, $date';
  }

  Map<String, String> get recipes => _recipes;
}
