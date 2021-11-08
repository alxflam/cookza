import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:flutter/material.dart';

class MutableMealPlan implements MealPlanEntity {
  final String? _id;

  final List<MutableMealPlanDateEntity> _items = [];

  final String _groupID;

  MutableMealPlan.of(
      String? id, String groupID, List<MealPlanDateEntity> items, int weeks,
      {DateTime? startDate})
      : this._id = id,
        this._groupID = groupID {
    init(items, weeks, startDate ?? DateTime.now());
  }

  @override
  String? get id => this._id;

  @override
  List<MutableMealPlanDateEntity> get items => this._items;

  void init(
      List<MealPlanDateEntity> entityItems, int weeks, DateTime startDate) {
    // identify the start date
    var firstDateToBeShown =
        DateTime.utc(startDate.year, startDate.month, startDate.day);

    // for each persisted item, use it if it is not in the past and contains any persisted state (recipes have been added)
    for (var item in entityItems) {
      bool skip = DateTime.utc(item.date.year, item.date.month, item.date.day)
          .isBefore(firstDateToBeShown);
      if (!skip && item.recipes.isNotEmpty) {
        this._items.add(MutableMealPlanDateEntity.of(item));
      }
    }

    // then identify the end date of the persisted state (if none is there - yesterdays date)
    var lastDate = items.isNotEmpty
        ? items.last.date
        : firstDateToBeShown.add(Duration(days: weeks * 7 - 1));

    // check if we start the period on a monday: we always want to show full weeks for the targetWeeks,
    // therefore if we open the meal plan on a wednesday and targetWeeks is two, we will have the rest of the week (5 days) + two weeks shown
    var offset = DateTime.monday == firstDateToBeShown.weekday
        ? -1
        : 7 - firstDateToBeShown.weekday;
    var minLastDate = firstDateToBeShown
        .add(Duration(days: offset))
        .add(Duration(days: weeks * 7));
    if (minLastDate.isAfter(lastDate)) {
      lastDate = minLastDate;
    }

    // next fill up dates currently not occupied (there has not been any persisted state for these)
    var days = lastDate.difference(firstDateToBeShown).inDays;
    this._sort();
    for (var i = 0; i <= days; i++) {
      // On the day when daylight savings time ends #add(Duration(days: 1))
      // won't necessarily compute the next day
      // (as it adds seconds but this special day has 25 hours),
      // therefore use UTC date
      var day = DateUtils.addDaysToDate(firstDateToBeShown, i);

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
  final DateTime _date;
  final List<MutableMealPlanRecipeEntity> _recipes;

  MutableMealPlanDateEntity.empty(DateTime date)
      : this._date = date,
        this._recipes = [];

  MutableMealPlanDateEntity.of(MealPlanDateEntity entity)
      : this._date = entity.date,
        this._recipes = List.of(entity.recipes
            .map((e) => MutableMealPlanRecipeEntity.of(e))
            .toList());

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
  final String? _id;

  String _name;

  int? _servings;

  MutableMealPlanRecipeEntity.fromValues(this._id, this._name, this._servings);

  MutableMealPlanRecipeEntity.of(MealPlanRecipeEntity entity)
      : this._id = entity.id,
        this._name = entity.name,
        this._servings = entity.servings;

  @override
  String? get id => this._id;

  @override
  String get name => this._name;

  @override
  int? get servings => this._servings;

  set servings(int? value) => this._servings = value;

  set name(String value) {
    assert(isNote);
    this._name = value;
  }

  @override
  bool get isNote => this._id == null;
}
