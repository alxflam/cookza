import 'dart:convert';

import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:flutter/material.dart';

abstract class GroupViewModel with ChangeNotifier {
  /// the name of the group
  String get name;

  /// rename the group
  Future<void> rename(String value);

  /// delete the group
  Future<void> delete();

  /// add the given user ID to the group with the given name
  Future<void> addUser(String id, String name);

  /// add the given user from the json content
  Future<UserEntity> addUserFromJson(String json) async {
    if (json != null && json.isNotEmpty) {
      var user = JsonUser.fromJson(jsonDecode(json));
      if (user.id == null ||
          user.id.isEmpty ||
          user.name == null ||
          user.name.isEmpty) {
        throw 'QR-Code does not contain a valid user ID and name';
      }
      var result = UserEntityJson.from(user);
      await this.addUser(result.id, result.name);
      return result;
    }
    return Future.value();
  }

  /// leave the group
  Future<void> leaveGroup();

  /// the list of members of this group
  Future<List<UserEntity>> members();

  /// remove member
  Future<void> removeMember(UserEntity user);
}
