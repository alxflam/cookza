import 'package:cookza/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exception_log.g.dart';

@JsonSerializable(includeIfNull: false)
class ExceptionItem {
  @JsonKey()
  String error;

  @JsonKey()
  String? stackTrace;

  @JsonKey(fromJson: kDateFromJson, toJson: kDateToJson)
  DateTime date;

  Map<String, dynamic> toJson() => _$ExceptionItemToJson(this);

  factory ExceptionItem.fromJson(Map<String, dynamic> json) =>
      _$ExceptionItemFromJson(json);

  ExceptionItem(
      {required this.error, required this.stackTrace, required this.date});
}

@JsonSerializable(includeIfNull: false)
class ExceptionLog {
  @JsonKey(toJson: kListToJson)
  List<ExceptionItem> errors;

  ExceptionLog({required this.errors});

  factory ExceptionLog.fromJson(Map<String, dynamic> json) =>
      _$ExceptionLogFromJson(json);

  Map<String, dynamic> toJson() => _$ExceptionLogToJson(this);
}
