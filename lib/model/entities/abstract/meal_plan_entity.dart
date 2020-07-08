abstract class MealPlanDateEntity {
  DateTime get date;

  List<MealPlanRecipeEntity> get recipes;
}

abstract class MealPlanRecipeEntity {
  String get name;
  String get id;
  int get servings;
  bool get isNote => id == null && servings == null;
}

abstract class MealPlanEntity {
  String get id;
  String get groupID;

  List<MealPlanDateEntity> get items;
}
