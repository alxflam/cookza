import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter/material.dart';

class MealDragModel {
  int _origin;
  MealPlanRecipeModel _recipe;

  MealPlanRecipeModel get model => _recipe;
  int get origin => _origin;

  MealDragModel(this._recipe, this._origin);
}

class MealPlanRecipeModel with ChangeNotifier {
  MutableMealPlanRecipeEntity _entity;

  MealPlanRecipeModel.of(MutableMealPlanRecipeEntity entity) {
    this._entity = entity;
  }

  bool get isNote => _entity.id == null;

  String get name => _entity.name;
  String get id => _entity.id;
  int get servings => _entity.servings;
  MealPlanRecipeEntity get entity => _entity;

  void setServings(BuildContext context, int value) {
    _entity.servings = value;
    notifyListeners();
  }
}

class MealPlanViewModel extends ChangeNotifier {
  RecipeEntity _recipeForAddition;
  MutableMealPlan _mealPlan;

  int _standardServings =
      sl.get<SharedPreferencesProvider>().getMealPlanStandardServingsSize();

  MealPlanViewModel.of(MealPlanEntity plan, {DateTime startDate}) {
    // first retrieve how many weeks should be shown
    var targetWeeks = sl.get<SharedPreferencesProvider>().getMealPlanWeeks();
    // create a mutable meal plan model
    _mealPlan = MutableMealPlan.of(plan, targetWeeks,
        startDate: startDate ?? DateTime.now());
  }

  // getters for UI wrap the mutable entity in change notifiers
  List<MealPlanDateEntry> get entries {
    return _mealPlan.items.map((e) => MealPlanDateEntry.of(e)).toList();
  }

  void _save() {
    sl.get<MealPlanManager>().saveMealPlan(this._mealPlan);
  }

  void moveRecipe(MealDragModel data, int target) {
    _mealPlan.items[data.origin].removeRecipe(data.model.entity);
    _mealPlan.items[target].addRecipe(data.model.entity);
    _save();
    notifyListeners();
  }

  void removeRecipe(MutableMealPlanRecipeEntity entity, int i) {
    _mealPlan.items[i].removeRecipe(entity);
    _save();
    notifyListeners();
  }

  void addRecipe(int index, String id) async {
    var recipe = await sl.get<RecipeManager>().getRecipeById([id]);
    var name = recipe != null ? recipe.first.name : 'unknown recipe';

    _mealPlan.items[index].addRecipe(
        MutableMealPlanRecipeEntity.fromValues(id, name, _standardServings));
    _save();
    notifyListeners();
  }

  void addRecipeFromEntity(int index, RecipeEntity entity) {
    _mealPlan.items[index].addRecipe(MutableMealPlanRecipeEntity.fromValues(
        entity.id, entity.name, _standardServings));
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

  void recipeModelChanged(MealPlanRecipeModel mealPlanRecipeModel) {
    this._save();
  }

  /// return the aggregated recipes for a given interval
  Map<String, int> getRecipesForInterval(
      DateTime firstDate, DateTime lastDate) {
    Map<String, int> result = {};
    for (var item in _mealPlan.items) {
      if (item.date.isAfter(firstDate.subtract(Duration(days: 1))) &&
          item.date.isBefore(lastDate.add(Duration(days: 1)))) {
        for (var recipe in item.recipes) {
          // only add real recipes, not notes
          if (recipe.id != null) {
            result.update(recipe.id, (value) => value + recipe.servings,
                ifAbsent: () => recipe.servings);
          }
        }
      }
    }
    return result;
  }

  void addNote(int index, String text) {
    _mealPlan.items[index]
        .addRecipe(MutableMealPlanRecipeEntity.fromValues(null, text, null));
    _save();
    notifyListeners();
  }
}

class MealPlanDateEntry with ChangeNotifier {
  MutableMealPlanDateEntity _entity;

  MealPlanDateEntry.of(MutableMealPlanDateEntity entity) {
    this._entity = entity;
  }

  factory MealPlanDateEntry.empty(DateTime date) {
    return MealPlanDateEntry.of(MutableMealPlanDateEntity.empty(date));
  }

  void addRecipe(MealPlanRecipeModel entry) {
    _entity.recipes.add(MutableMealPlanRecipeEntity.of(entry.entity));
  }

  void removeRecipe(String id) {
    _entity.recipes.removeWhere((element) => element.id == id);
  }

  int get week => weekNumberOf(_entity.date);

  DateTime get date => _entity.date;

  List<MealPlanRecipeModel> get recipes =>
      _entity.recipes.map((e) => MealPlanRecipeModel.of(e)).toList();

  // MealPlanItem toMealPlanItem() {
  //   Map<String, int> recipeReferences = Map.fromIterable(this._recipes.values,
  //       key: (e) => e.id, value: (e) => e.servings);
  //   return MealPlanDateEntry(date: this._date, recipeReferences: recipeReferences);
  // }
}
