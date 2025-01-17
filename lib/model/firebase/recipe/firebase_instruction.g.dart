// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseInstruction _$FirebaseInstructionFromJson(Map<String, dynamic> json) =>
    FirebaseInstruction(
      step: (json['step'] as num?)?.toInt(),
      text: json['text'] as String,
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$FirebaseInstructionToJson(
        FirebaseInstruction instance) =>
    <String, dynamic>{
      if (instance.step case final value?) 'step': value,
      'text': instance.text,
      if (instance.imagePath case final value?) 'imagePath': value,
    };

FirebaseInstructionDocument _$FirebaseInstructionDocumentFromJson(
        Map<String, dynamic> json) =>
    FirebaseInstructionDocument(
      recipeID: json['recipeID'] as String,
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => FirebaseInstruction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirebaseInstructionDocumentToJson(
        FirebaseInstructionDocument instance) =>
    <String, dynamic>{
      'recipeID': instance.recipeID,
      if (kListToJson(instance.instructions) case final value?)
        'instructions': value,
    };
