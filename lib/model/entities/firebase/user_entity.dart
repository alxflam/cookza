import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/firebase/general/firebase_user.dart';

class UserEntityFirebase implements UserEntity {
  FirebaseRecipeUser _user;

  UserEntityFirebase.from(FirebaseRecipeUser user) {
    this._user = user;
  }

  @override
  String get id => this._user.id;

  @override
  String get name => this._user.name;

  @override
  USER_TYPE get type {
    if (this._user.name == 'web') {
      return USER_TYPE.WEB_SESSION;
    }
    return USER_TYPE.USER;
  }
}