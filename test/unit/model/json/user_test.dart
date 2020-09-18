import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/json/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('User from JSON', () async {
    var json = {
      'name': 'Bond, James Bond',
      'id': '12',
      'type': 'USER',
    };
    var cut = JsonUser.fromJson(json);

    expect(cut.name, 'Bond, James Bond');
    expect(cut.id, '12');
    expect(cut.type, USER_TYPE.USER);
  });

  test('User to JSON', () async {
    var json = {
      'id': '12',
      'name': 'Bond, James Bond',
      'type': 'USER',
    };
    var cut = JsonUser.fromJson(json);
    var actual = cut.toJson();
    expect(actual, json);
  });
}
