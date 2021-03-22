import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/firebase/meal_plan/firebase_meal_plan.dart';

class MealPlanDateEntityFirebase implements MealPlanDateEntity {
  DateTime _date;
  List<MealPlanRecipeEntity> _recipes;

  MealPlanDateEntityFirebase.of(FirebaseMealPlanDate item)
      : this._date = item.date,
        this._recipes = item.recipes
            .map((e) => MealPlanRecipeEntityFirebase.of(e))
            .toList();

  @override
  DateTime get date => this._date;

  @override
  List<MealPlanRecipeEntity> get recipes => this._recipes;
}

class MealPlanRecipeEntityFirebase implements MealPlanRecipeEntity {
  String _id;
  String _name;
  int _servings;

  MealPlanRecipeEntityFirebase.of(FirebaseMealPlanRecipe item)
      : this._id = item.id,
        this._name = item.name,
        this._servings = item.servings;

  @override
  String get id => this._id;

  @override
  String get name => this._name;

  @override
  int get servings => this._servings;

  @override
  bool get isNote => this._id == null || this._id.isEmpty;
}

class MealPlanEntityFirebase implements MealPlanEntity {
  List<MealPlanDateEntity> _items;
  String? _id;

  String _groupID;

  MealPlanEntityFirebase.of(FirebaseMealPlanDocument document)
      : this._id = document.documentID,
        this._groupID = document.groupID,
        this._items = document.items
            .map((e) => MealPlanDateEntityFirebase.of(e))
            .toList();

  @override
  List<MealPlanDateEntity> get items => this._items;

  @override
  String? get id => this._id;

  @override
  String get groupID => this._groupID;
}
