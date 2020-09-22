import 'package:flutter/widgets.dart';

abstract class IdGenerator {
  String get id;
}

class UniqueKeyIdGenerator implements IdGenerator {
  @override
  String get id {
    String key = UniqueKey().toString();
    key = key.trim();
    key = key.replaceFirst('[#', '');
    key = key.replaceFirst(']', '');
    return key;
  }
}
