enum USER_TYPE { USER, WEB_SESSION }

abstract class UserEntity {
  String get id;
  String get name;
  USER_TYPE get type;
}
