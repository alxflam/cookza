// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_handshake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseHandshake _$FirebaseHandshakeFromJson(Map<String, dynamic> json) {
  return FirebaseHandshake(
    requestor: json['requestor'] as String,
    owner: json['owner'] as String,
    creationTimestamp: kTimestampFromJson(json['creationTimestamp']),
    operatingSystem: json['operatingSystem'] as String,
    browser: json['browser'] as String,
  );
}

Map<String, dynamic> _$FirebaseHandshakeToJson(FirebaseHandshake instance) =>
    <String, dynamic>{
      'requestor': instance.requestor,
      'owner': instance.owner,
      'creationTimestamp': kTimestampToJson(instance.creationTimestamp),
      'operatingSystem': instance.operatingSystem,
      'browser': instance.browser,
    };
