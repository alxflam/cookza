import 'dart:collection';

import 'package:cookza/model/entities/abstract/user_entity.dart';

abstract class RecipeCollectionEntity {
  String? get id;
  String get name;
  DateTime get creationTimestamp;
  UnmodifiableListView<UserEntity> get users;
}
