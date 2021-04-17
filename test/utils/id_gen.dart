import 'package:flutter/widgets.dart';

class UniqueKeyIdGenerator {
  String get id {
    String key = UniqueKey().toString();
    key = key.trim();
    key = key.replaceFirst('[#', '');
    key = key.replaceFirst(']', '');
    return key;
  }
}
