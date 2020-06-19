// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseInstruction _$FirebaseInstructionFromJson(Map<String, dynamic> json) {
  return FirebaseInstruction(
    step: json['step'] as int,
    text: json['text'] as String,
    imagePath: json['imagePath'] as String,
  );
}

Map<String, dynamic> _$FirebaseInstructionToJson(FirebaseInstruction instance) {
  final val = <String, dynamic>{
    'step': instance.step,
    'text': instance.text,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imagePath', instance.imagePath);
  return val;
}

FirebaseInstructionDocument _$FirebaseInstructionDocumentFromJson(
    Map<String, dynamic> json) {
  return FirebaseInstructionDocument(
    recipeID: json['recipeID'] as String,
    instructions: (json['instructions'] as List)
        ?.map((e) => e == null
            ? null
            : FirebaseInstruction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FirebaseInstructionDocumentToJson(
    FirebaseInstructionDocument instance) {
  final val = <String, dynamic>{
    'recipeID': instance.recipeID,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('instructions', kListToJson(instance.instructions));
  return val;
}
