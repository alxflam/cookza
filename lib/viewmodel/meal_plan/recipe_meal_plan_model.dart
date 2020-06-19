import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/recipe_manager.dart';
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
  RecipeEntity _recipeForAddition;

  // TODO: create mutable version of MealPlanEntity!!
  MealPlanViewModel.of(this._locale, MealPlanEntity plan) {
    // first retrieve how many weeks should be shown
    var targetWeeks = sl.get<SharedPreferencesProvider>().getMealPlanWeeks();

    // then identify the start date
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    // for each persisted item, use it if it is not in the past and contains any persisted state (recipes have been added)
    for (var item in plan.items) {
      bool skip = item.date.isBefore(today);
      if (!skip && item.recipes != null && item.recipes.isNotEmpty) {
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
    // sl.get<MealPlanManager>().updateMealPlan(this._toMealPlan());
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

  void addRecipe(int index, String id) async {
    var recipe = await sl.get<RecipeManager>().getRecipeById(id);
    var name = recipe != null ? recipe.name : 'unknown recipe';
    var servings =
        sl.get<SharedPreferencesProvider>().getMealPlanStandardServingsSize();

    entries[index].addRecipe(MealPlanRecipeModel(id, name, servings));
    _save();
    notifyListeners();
  }

  void addRecipeFromEntity(int index, RecipeEntity entity) {
    entries[index].addRecipe(
        MealPlanRecipeModel(entity.id, entity.name, entity.servings));
    _save();
    notifyListeners();
  }

  void setRecipeForAddition(RecipeEntity recipe) {
    _recipeForAddition = recipe;
  }

  void addByNavigation(int index) {
    addRecipeFromEntity(index, _recipeForAddition);
    _recipeForAddition = null;
    notifyListeners();
  }

  bool get addByNavigationRequired =>
      _recipeForAddition != null && _recipeForAddition.id.isNotEmpty
          ? true
          : false;

  MealPlanEntity _toMealPlan() {
    // List<MealPlanDateItem> items = [];

    // for (var entry in entries) {
    //   items.add(entry.toMealPlanItem());
    // }

    // return MealPlanEntityFirebase.
    return null;
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

  MealPlanDateEntry.of(this._locale, MealPlanDateEntity item) {
    this._date = item.date;
    for (var entry in item.recipes) {
      this.addRecipe(MealPlanRecipeModel(entry.id, entry.name, entry.servings));
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
    // TODO: keep the formatter static somewhere
    var day = DateFormat.EEEE(this._locale.toString()).format(_date);
    var date = DateFormat('d.MM.yyyy').format(_date);
    return '$day, $date';
  }

  int get week => weekNumberOf(_date);

  DateTime get date => _date;

  List<MealPlanRecipeModel> get recipes => _recipes.values.toList();

  // MealPlanItem toMealPlanItem() {
  //   Map<String, int> recipeReferences = Map.fromIterable(this._recipes.values,
  //       key: (e) => e.id, value: (e) => e.servings);
  //   return MealPlanDateEntry(date: this._date, recipeReferences: recipeReferences);
  // }
}
