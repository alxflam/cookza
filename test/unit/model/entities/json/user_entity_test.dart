import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Create User',
    () async {
      var user = JsonUser(id: '1234', name: 'John Doe', type: USER_TYPE.USER);
      var cut = UserEntityJson.from(user);

      expect(cut.id, '1234');
      expect(cut.name, 'John Doe');
      expect(cut.type, USER_TYPE.USER);
    },
  );
}
