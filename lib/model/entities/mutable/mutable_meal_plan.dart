import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';

class MutableMealPlan implements MealPlanEntity {
  String _id;

  List<MutableMealPlanDateEntity> _items = [];

  String _groupID;

  MutableMealPlan.of(MealPlanEntity entity, int weeks) {
    this._id = entity.id;
    this._groupID = entity.groupID;
    init(entity, weeks);
  }

  MutableMealPlan.withPreferenceWeeks(MealPlanEntity entity) {
    this._id = entity.id;
    this._groupID = entity.groupID;
    var weeks = sl.get<SharedPreferencesProvider>().getMealPlanWeeks();
    init(entity, weeks);
  }

  @override
  String get id => this._id;

  @override
  List<MutableMealPlanDateEntity> get items => this._items;

  void init(MealPlanEntity entity, int weeks) {
    // identify the start date
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    // for each persisted item, use it if it is not in the past and contains any persisted state (recipes have been added)
    for (var item in entity.items) {
      bool skip = item.date.isBefore(today);
      if (!skip && item.recipes != null && item.recipes.isNotEmpty) {
        this._items.add(MutableMealPlanDateEntity.of(item));
      }
    }

    // then identify the end date of the persisted state (if none is there - yesterdays date)
    var lastDate = items.isNotEmpty
        ? items.last.date
        : today.add(Duration(days: weeks * 7));

    // check if we start the period on a monday: we always want to show full weeks for the targetWeeks,
    // therefore if we open the meal plan on a wednesday and targetWeeks is two, we will have the rest of the week (5 days) + two weeks shown
    var offset = DateTime.monday == today.weekday ? -1 : 7 - today.weekday;
    var minLastDate =
        today.add(Duration(days: offset)).add(Duration(days: weeks * 7));
    if (minLastDate.isAfter(lastDate)) {
      lastDate = minLastDate;
    }

    // next fill up dates currently not occupied (there has not been any persisted state for these)
    var days = lastDate.difference(today).inDays;
    this._sort();
    for (var i = 0; i <= days; i++) {
      var day = today.add(Duration(days: i));

      if (items.length <= i || !isSameDay(items[i].date, day)) {
        _items.add(MutableMealPlanDateEntity.empty(day));
        this._sort();
      }
    }

    // ensure order is correct
    this._sort();
  }

  void _sort() {
    this._items.sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  String get groupID => this._groupID;
}

class MutableMealPlanDateEntity implements MealPlanDateEntity {
  DateTime _date;
  List<MutableMealPlanRecipeEntity> _recipes;

  MutableMealPlanDateEntity.empty(DateTime date) {
    this._date = date;
    this._recipes = [];
  }

  MutableMealPlanDateEntity.of(MealPlanDateEntity entity) {
    this._date = entity.date;
    this._recipes = List.of(
        entity.recipes.map((e) => MutableMealPlanRecipeEntity.of(e)).toList());
  }
  @override
  DateTime get date => this._date;

  @override
  List<MutableMealPlanRecipeEntity> get recipes => this._recipes;

  void removeRecipe(MealPlanRecipeEntity entity) {
    if (entity.isNote) {
      var object = _recipes.firstWhere((e) =>
          e.name == entity.name &&
          e.id == entity.id &&
          e.servings == entity.servings);

      _recipes.remove(object);
    } else {
      _recipes.removeWhere((e) => e.id == entity.id);
    }
  }

  void addRecipe(MealPlanRecipeEntity entity) {
    _recipes.add(MutableMealPlanRecipeEntity.of(entity));
  }
}

class MutableMealPlanRecipeEntity implements MealPlanRecipeEntity {
  String _id;

  String _name;

  int _servings;

  MutableMealPlanRecipeEntity.fromValues(this._id, this._name, this._servings);

  MutableMealPlanRecipeEntity.of(MealPlanRecipeEntity entity) {
    this._id = entity.id;
    this._name = entity.name;
    this._servings = entity.servings;
  }

  @override
  String get id => this._id;

  @override
  String get name => this._name;

  @override
  int get servings => this._servings;

  set servings(int value) => this._servings = value;

  @override
  bool get isNote => this._id == null && this._servings == null;
}
