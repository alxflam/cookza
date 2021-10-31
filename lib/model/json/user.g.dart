// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonUser _$JsonUserFromJson(Map<String, dynamic> json) => JsonUser(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$USER_TYPEEnumMap, json['type']),
    );

Map<String, dynamic> _$JsonUserToJson(JsonUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$USER_TYPEEnumMap[instance.type],
    };

const _$USER_TYPEEnumMap = {
  USER_TYPE.USER: 'USER',
  USER_TYPE.WEB_SESSION: 'WEB_SESSION',
};
