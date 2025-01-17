// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionItem _$ExceptionItemFromJson(Map<String, dynamic> json) =>
    ExceptionItem(
      error: json['error'] as String,
      stackTrace: json['stackTrace'] as String?,
      date: kDateFromJson(json['date'] as String),
    );

Map<String, dynamic> _$ExceptionItemToJson(ExceptionItem instance) =>
    <String, dynamic>{
      'error': instance.error,
      if (instance.stackTrace case final value?) 'stackTrace': value,
      'date': kDateToJson(instance.date),
    };

ExceptionLog _$ExceptionLogFromJson(Map<String, dynamic> json) => ExceptionLog(
      errors: (json['errors'] as List<dynamic>)
          .map((e) => ExceptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExceptionLogToJson(ExceptionLog instance) =>
    <String, dynamic>{
      if (kListToJson(instance.errors) case final value?) 'errors': value,
    };
