import 'package:cookly/model/json/meal_plan.dart';
import 'package:cookly/model/json/meal_plan_item.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MealDragModel {
  int _origin;
  MealPlanRecipeModel _recipe;

  MealPlanRecipeModel get model => _recipe;
  int get origin => _origin;

  MealDragModel(this._recipe, this._origin);
}

class MealPlanRecipeModel {
  String _name;
  String _id;
  int _servings;

  MealPlanRecipeModel(this._id, this._name, this._servings);

  String get name => _name;
  String get id => _id;
  int get servings => _servings;
}

class MealPlanViewModel extends ChangeNotifier {
  List<MealPlanDateEntry> entries = [];
  Locale _locale;
  String _recipeIdForAddition;

  MealPlanViewModel.of(this._locale, MealPlan plan) {
    for (var item in plan.items) {
      bool skip = item.date.isBefore(DateTime.now().add(Duration(days: 1)));
      if (!skip) {
        entries.add(MealPlanDateEntry.of(_locale, item));
      }
    }

    var lastDate = entries.isNotEmpty
        ? entries.last._date
        : DateTime.now().subtract(Duration(days: 1));
    var targetLastDate = DateTime.now().add(Duration(days: 13));
    var missingDays = lastDate.difference(targetLastDate).inDays;
    missingDays = missingDays < 0 ? missingDays * -1 : missingDays;
    // add the missing days so we always have a list of two weeks
    // TODO: make this a preference setting (e.g. 7, 14, or custom amount of days)
    for (var i = 0; i < missingDays; i++) {
      entries.add(MealPlanDateEntry.empty(
          _locale, lastDate.add(Duration(days: i + 1))));
    }
    for (var i = 0; i < entries.length; i = i + 2) {
      if (i < entries.length - 1) {
        var date = entries[i]._date;
        var nextDate = entries[i + 1]._date;
        var diffDays = date.difference(nextDate).inDays;
        if (diffDays > 1) {
          // TODO: fix gaps in data => no days need to be stored which do not contain any data
          throw 'corrupted data';
        }
      }
    }

    // ensure order is correct
    this._sort();
  }

  void _sort() {
    this.entries.sort((a, b) => a._date.compareTo(b._date));
  }

  void _save() {
    sl.get<DataStore>().appProfile.updateMealPlan(this._toMealPlan());
  }

  void moveRecipe(MealDragModel data, int target) {
    entries[data.origin].removeRecipe(data.model.id);
    entries[target].addRecipe(data.model);
    _save();
    notifyListeners();
  }

  void removeRecipe(String id, int i) {
    entries[i].removeRecipe(id);
    _save();
    notifyListeners();
  }

  void addRecipe(int index, String id) {
    var name = sl.get<DataStore>().appProfile.getRecipeById(id)?.name;
    var servings =
        sl.get<SharedPreferencesProvider>().getMealPlanStandardServingsSize();

    entries[index].addRecipe(MealPlanRecipeModel(id, name, servings));
    _save();
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

  MealPlan _toMealPlan() {
    List<MealPlanItem> items = [];

    for (var entry in entries) {
      items.add(entry.toMealPlanItem());
    }

    return MealPlan(items: items);
  }
}

class MealPlanDateEntry {
  DateTime _date;
  Map<String, MealPlanRecipeModel> _recipes = {};
  Locale _locale;

  MealPlanDateEntry.of(this._locale, MealPlanItem item) {
    this._date = item.date;
    for (var entry in item.recipeReferences.entries) {
      var name = sl.get<DataStore>().appProfile.getRecipeById(entry.key)?.name;
      this.addRecipe(MealPlanRecipeModel(entry.key, name, entry.value));
    }
  }

  MealPlanDateEntry.empty(this._locale, this._date);

  void addRecipe(MealPlanRecipeModel entry) {
    _recipes.putIfAbsent(entry.id, () => entry);
  }

  void removeRecipe(String id) {
    _recipes.remove(id);
  }

  String get header {
    var day = DateFormat.EEEE(this._locale.toString()).format(_date);
    var date = DateFormat('d.MM.yyyy').format(_date);
    return '$day, $date';
  }

  int get week => weekNumberOf(_date);

  List<MealPlanRecipeModel> get recipes => _recipes.values.toList();

  MealPlanItem toMealPlanItem() {
    Map<String, int> recipeReferences = Map.fromIterable(this._recipes.values,
        key: (e) => e.id, value: (e) => e.servings);
    return MealPlanItem(date: this._date, recipeReferences: recipeReferences);
  }
}
