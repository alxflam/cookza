// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMealPlanRecipe _$FirebaseMealPlanRecipeFromJson(
        Map<String, dynamic> json) =>
    FirebaseMealPlanRecipe(
      name: json['name'] as String,
      id: json['id'] as String?,
      servings: (json['servings'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FirebaseMealPlanRecipeToJson(
        FirebaseMealPlanRecipe instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.id case final value?) 'id': value,
      if (instance.servings case final value?) 'servings': value,
    };

FirebaseMealPlanDate _$FirebaseMealPlanDateFromJson(
        Map<String, dynamic> json) =>
    FirebaseMealPlanDate(
      date: kDateFromJson(json['date'] as String),
      recipes: (json['recipes'] as List<dynamic>)
          .map(
              (e) => FirebaseMealPlanRecipe.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirebaseMealPlanDateToJson(
        FirebaseMealPlanDate instance) =>
    <String, dynamic>{
      'date': kDateToJson(instance.date),
      if (kListToJson(instance.recipes) case final value?) 'recipes': value,
    };

FirebaseMealPlanDocument _$FirebaseMealPlanDocumentFromJson(
        Map<String, dynamic> json) =>
    FirebaseMealPlanDocument(
      items: (json['items'] as List<dynamic>)
          .map((e) => FirebaseMealPlanDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupID: json['groupID'] as String,
    );

Map<String, dynamic> _$FirebaseMealPlanDocumentToJson(
        FirebaseMealPlanDocument instance) =>
    <String, dynamic>{
      if (kListToJson(instance.items) case final value?) 'items': value,
      'groupID': instance.groupID,
    };
