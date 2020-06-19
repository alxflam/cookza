import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_meal_plan.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseMealPlanRecipe {
  @JsonKey(nullable: false)
  String name;
  @JsonKey(nullable: false)
  String id;
  @JsonKey(nullable: false)
  int servings;

  FirebaseMealPlanRecipe({this.name, this.id, this.servings});

  factory FirebaseMealPlanRecipe.fromJson(Map<String, dynamic> json) {
    return _$FirebaseMealPlanRecipeFromJson(json);
  }

  factory FirebaseMealPlanRecipe.from(MealPlanRecipeEntity entity) {
    return FirebaseMealPlanRecipe(
        name: entity.name, id: entity.id, servings: entity.servings);
  }

  Map<String, dynamic> toJson() => _$FirebaseMealPlanRecipeToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FirebaseMealPlanDate {
  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime date;

  @JsonKey(toJson: kListToJson)
  List<FirebaseMealPlanRecipe> recipes;

  FirebaseMealPlanDate({this.date, this.recipes});

  factory FirebaseMealPlanDate.fromJson(Map<String, dynamic> json) {
    return _$FirebaseMealPlanDateFromJson(json);
  }

  factory FirebaseMealPlanDate.from(MealPlanDateEntity entity) {
    return FirebaseMealPlanDate(
        date: entity.date,
        recipes:
            entity.recipes.map((e) => FirebaseMealPlanRecipe.from(e)).toList());
  }

  Map<String, dynamic> toJson() => _$FirebaseMealPlanDateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FirebaseMealPlanDocument {
  @JsonKey(ignore: true)
  String documentID;

  @JsonKey(toJson: kListToJson)
  List<FirebaseMealPlanDate> items;

  @JsonKey(nullable: false)
  Map<String, String> users;

  FirebaseMealPlanDocument({this.documentID, this.items, this.users});

  factory FirebaseMealPlanDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseMealPlanDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseMealPlanDocumentToJson(this);

  static from(MealPlanEntity entity) {
    var users =
        Map.fromIterable(entity.users, key: (e) => e.id, value: (e) => e.name);
    var items = entity.items.map((e) => FirebaseMealPlanDate.from(e)).toList();
    return FirebaseMealPlanDocument(items: items, users: users);
  }

  static empty(String userID) {
    return FirebaseMealPlanDocument(items: [], users: {userID: 'OWNER'});
  }
}
