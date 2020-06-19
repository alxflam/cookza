import 'package:cookly/model/firebase/general/firebase_user.dart';

enum USER_TYPE { USER, WEB_SESSION }

abstract class UserEntity {
  String get id;
  String get name;
  USER_TYPE get type;
}

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
  USER_TYPE get type => throw UnimplementedError();
}
