import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:flutter/material.dart';

class MealDragModel {
  final int _origin;
  final MealPlanRecipeModel _recipe;

  MealPlanRecipeModel get model => _recipe;
  int get origin => _origin;

  MealDragModel(this._recipe, this._origin);
}

class MealPlanRecipeModel with ChangeNotifier {
  MutableMealPlanRecipeEntity _entity;

  MealPlanRecipeModel.of(MutableMealPlanRecipeEntity entity)
      : this._entity = entity;

  bool get isNote => _entity.id == null;

  String get name => _entity.name;
  String? get id => _entity.id;
  int get servings => _entity.servings;
  MealPlanRecipeEntity get entity => _entity;

  set servings(int value) {
    _entity.servings = value;
    notifyListeners();
  }

  set name(String value) {
    this._entity.name = value;
    notifyListeners();
  }
}

class MealPlanViewModel extends ChangeNotifier {
  RecipeEntity? _recipeForAddition;
  late MutableMealPlan _mealPlan;

  final int _standardServings =
      sl.get<SharedPreferencesProvider>().getMealPlanStandardServingsSize();

  MealPlanViewModel.of(MealPlanEntity plan, {DateTime? startDate}) {
    // first retrieve how many weeks should be shown
    var targetWeeks = sl.get<SharedPreferencesProvider>().getMealPlanWeeks();
    // create a mutable meal plan model
    _mealPlan = MutableMealPlan.of(
        plan.id!, plan.groupID, plan.items, targetWeeks,
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

  void addRecipeFromEntity(int index, RecipeEntity? entity) {
    if (entity == null) {
      return;
    }
    _mealPlan.items[index].addRecipe(MutableMealPlanRecipeEntity.fromValues(
        entity.id, entity.name, _standardServings));
    _save();
    notifyListeners();
  }

  void setRecipeForAddition(RecipeEntity recipe) {
    _recipeForAddition = recipe;
  }

  void addByNavigation(int index) {
    if (_recipeForAddition == null) {
      return;
    }
    addRecipeFromEntity(index, _recipeForAddition);
    _recipeForAddition = null;
    notifyListeners();
  }

  bool get addByNavigationRequired =>
      _recipeForAddition != null && _recipeForAddition!.id!.isNotEmpty
          ? true
          : false;

  void recipeModelChanged(MealPlanRecipeModel mealPlanRecipeModel) {
    this._save();
  }

  void addNote(int index, String text) {
    _mealPlan.items[index]
        .addRecipe(MutableMealPlanRecipeEntity.fromValues(null, text, 1));
    _save();
    notifyListeners();
  }
}

class MealPlanDateEntry with ChangeNotifier {
  final MutableMealPlanDateEntity _entity;

  MealPlanDateEntry.of(MutableMealPlanDateEntity entity)
      : this._entity = entity;

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
}
