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
      servings: json['servings'] as int?,
    );

Map<String, dynamic> _$FirebaseMealPlanRecipeToJson(
    FirebaseMealPlanRecipe instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('servings', instance.servings);
  return val;
}

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
        Map<String, dynamic> json) =>
    FirebaseMealPlanDocument(
      items: (json['items'] as List<dynamic>)
          .map((e) => FirebaseMealPlanDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupID: json['groupID'] as String,
    );

Map<String, dynamic> _$FirebaseMealPlanDocumentToJson(
    FirebaseMealPlanDocument instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', kListToJson(instance.items));
  val['groupID'] = instance.groupID;
  return val;
}
