import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonUser {
  @JsonKey(nullable: false)
  String id;
  @JsonKey(nullable: false)
  String name;
  @JsonKey(nullable: false)
  USER_TYPE type;

  factory JsonUser.fromJson(Map<String, dynamic> json) {
    var instance = _$JsonUserFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$JsonUserToJson(this);

  JsonUser({
    this.id,
    this.name,
    this.type,
  }) {
    assert(this.id != null);
  }
}
