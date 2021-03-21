import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonUser {
  @JsonKey()
  String id;
  @JsonKey()
  String name;
  @JsonKey()
  USER_TYPE type;

  factory JsonUser.fromJson(Map<String, dynamic> json) {
    var instance = _$JsonUserFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$JsonUserToJson(this);

  JsonUser({
    required this.id,
    required this.name,
    required this.type,
  });
}
