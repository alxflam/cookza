// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionItem _$ExceptionItemFromJson(Map<String, dynamic> json) {
  return ExceptionItem(
    error: json['error'] as String,
    stackTrace: json['stackTrace'] as String,
    date: kDateFromJson(json['date'] as String),
  );
}

Map<String, dynamic> _$ExceptionItemToJson(ExceptionItem instance) {
  final val = <String, dynamic>{
    'error': instance.error,
    'stackTrace': instance.stackTrace,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', kDateToJson(instance.date));
  return val;
}

ExceptionLog _$ExceptionLogFromJson(Map<String, dynamic> json) {
  return ExceptionLog(
    errors: (json['errors'] as List<dynamic>)
        .map((e) => ExceptionItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ExceptionLogToJson(ExceptionLog instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('errors', kListToJson(instance.errors));
  return val;
}
