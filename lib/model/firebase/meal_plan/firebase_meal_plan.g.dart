// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMealPlanRecipe _$FirebaseMealPlanRecipeFromJson(
    Map<String, dynamic> json) {
  return FirebaseMealPlanRecipe(
    name: json['name'] as String,
    id: json['id'] as String,
    servings: json['servings'] as int,
  );
}

Map<String, dynamic> _$FirebaseMealPlanRecipeToJson(
        FirebaseMealPlanRecipe instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'servings': instance.servings,
    };

FirebaseMealPlanDate _$FirebaseMealPlanDateFromJson(Map<String, dynamic> json) {
  return FirebaseMealPlanDate(
    date: kDateFromJson(json['date'] as String),
    recipes: (json['recipes'] as List)
        ?.map((e) => e == null
            ? null
            : FirebaseMealPlanRecipe.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FirebaseMealPlanDateToJson(
    FirebaseMealPlanDate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', kDateToJson(instance.date));
  writeNotNull('recipes', kListToJson(instance.recipes));
  return val;
}

FirebaseMealPlanDocument _$FirebaseMealPlanDocumentFromJson(
    Map<String, dynamic> json) {
  return FirebaseMealPlanDocument(
    items: (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : FirebaseMealPlanDate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    users: Map<String, String>.from(json['users'] as Map),
  );
}

Map<String, dynamic> _$FirebaseMealPlanDocumentToJson(
    FirebaseMealPlanDocument instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', kListToJson(instance.items));
  val['users'] = instance.users;
  return val;
}