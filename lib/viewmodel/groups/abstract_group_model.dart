import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class GroupViewModel with ChangeNotifier {
  /// the name of the group
  String get name;

  /// rename the group
  Future<void> rename(String value);

  /// delete the group
  Future<void> delete();

  /// add the given user ID to the group witht the given name
  Future<void> addUser(String id, String name);

  /// leave the group
  Future<void> leaveGroup();

  /// the list of members of this group
  Future<List<UserEntity>> members();
}
