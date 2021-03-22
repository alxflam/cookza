import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/user.dart';

class UserEntityJson implements UserEntity {
  final JsonUser _user;

  UserEntityJson.from(this._user);

  @override
  String get id => this._user.id;

  @override
  String get name => this._user.name;

  @override
  USER_TYPE get type => this._user.type;
}
