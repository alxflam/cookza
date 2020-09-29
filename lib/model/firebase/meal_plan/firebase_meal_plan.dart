import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
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

  // @JsonKey(nullable: false)
  // Map<String, String> users;

  @JsonKey(nullable: false)
  String groupID;

  FirebaseMealPlanDocument({this.documentID, this.items, this.groupID});

  factory FirebaseMealPlanDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseMealPlanDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseMealPlanDocumentToJson(this);

  static FirebaseMealPlanDocument from(MealPlanEntity entity) {
    var items = entity.items
        .where((e) => e.recipes.isNotEmpty)
        .map((e) => FirebaseMealPlanDate.from(e))
        .toList();
    return FirebaseMealPlanDocument(items: items, groupID: entity.groupID);
  }

  static FirebaseMealPlanDocument empty(String userID, String groupID) {
    return FirebaseMealPlanDocument(groupID: groupID, items: []);
  }
}
