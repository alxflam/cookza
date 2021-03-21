// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonUser _$JsonUserFromJson(Map<String, dynamic> json) {
  return JsonUser(
    id: json['id'] as String,
    name: json['name'] as String,
    type: _$enumDecode(_$USER_TYPEEnumMap, json['type']),
  );
}

Map<String, dynamic> _$JsonUserToJson(JsonUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$USER_TYPEEnumMap[instance.type],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$USER_TYPEEnumMap = {
  USER_TYPE.USER: 'USER',
  USER_TYPE.WEB_SESSION: 'WEB_SESSION',
};
