import 'package:cookly/model/json/meal_plan.dart';
import 'package:cookly/model/json/meal_plan_item.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealDragModel {
  int _origin;
  MealPlanRecipeModel _recipe;

  MealPlanRecipeModel get model => _recipe;
  int get origin => _origin;

  MealDragModel(this._recipe, this._origin);
}

class MealPlanRecipeModel with ChangeNotifier {
  String _name;
  String _id;
  int _servings;

  MealPlanRecipeModel(this._id, this._name, this._servings);

  String get name => _name;
  String get id => _id;
  int get servings => _servings;

  void setServings(BuildContext context, int value) {
    _servings = value;
    notifyListeners();
  }
}

class MealPlanViewModel extends ChangeNotifier {
  List<MealPlanDateEntry> entries = [];
  Locale _locale;
  String _recipeIdForAddition;

  MealPlanViewModel.of(this._locale, MealPlan plan) {
    // first retrieve how many weeks should be shown
    var targetWeeks = sl.get<SharedPreferencesProvider>().getMealPlanWeeks();

    // then identify the start date
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    // for each persisted item, use it if it is not in the past and contains any persisted state (recipes have been added)
    for (var item in plan.items) {
      bool skip = item.date.isBefore(today);
      if (!skip &&
          item.recipeReferences != null &&
          item.recipeReferences.isNotEmpty) {
        entries.add(MealPlanDateEntry.of(_locale, item));
      }
    }

    // then identify the end date of the persisted state (if none is there - yesterdays date)
    var lastDate = entries.isNotEmpty
        ? entries.last._date
        : today.add(Duration(days: targetWeeks * 7));

    // check if we start the period on a monday: we always want to show full weeks for the targetWeeks,
    // therefore if we open the meal plan on a wednesday and targetWeeks is two, we will have the rest of the week (5 days) + two weeks shown
    var offset = DateTime.monday == today.weekday ? -1 : 7 - today.weekday;
    var minLastDate =
        today.add(Duration(days: offset)).add(Duration(days: targetWeeks * 7));
    if (minLastDate.isAfter(lastDate)) {
      lastDate = minLastDate;
    }

    // next fill up dates currently not occupied (there has not been any persisted state for these)
    var days = lastDate.difference(today).inDays;
    this._sort();
    for (var i = 0; i <= days; i++) {
      var day = today.add(Duration(days: i));

      if (entries.length <= i || !isSameDay(entries[i]._date, day)) {
        entries.add(MealPlanDateEntry.empty(_locale, day));
        this._sort();
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

  void recipeModelChanged(MealPlanRecipeModel mealPlanRecipeModel) {
    this._save();
  }

  Map<String, int> getRecipesForInterval(
      DateTime firstDate, DateTime lastDate) {
    Map<String, int> result = {};
    for (var item in entries) {
      if (item.date.isAfter(firstDate.subtract(Duration(days: 1))) &&
          item.date.isBefore(lastDate.add(Duration(days: 1)))) {
        for (var recipe in item.recipes) {
          result.update(recipe.id, (value) => value + recipe.servings,
              ifAbsent: () => recipe.servings);
        }
      }
    }
    return result;
  }
}

class MealPlanDateEntry with ChangeNotifier {
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

  DateTime get date => _date;

  List<MealPlanRecipeModel> get recipes => _recipes.values.toList();

  MealPlanItem toMealPlanItem() {
    Map<String, int> recipeReferences = Map.fromIterable(this._recipes.values,
        key: (e) => e.id, value: (e) => e.servings);
    return MealPlanItem(date: this._date, recipeReferences: recipeReferences);
  }
}
