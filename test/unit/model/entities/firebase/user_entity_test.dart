import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/user_entity.dart';
import 'package:cookza/model/firebase/general/firebase_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'user is web session',
    () async {
      var user = FirebaseRecipeUser(name: 'web', id: '');
      var cut = UserEntityFirebase.from(user);
      expect(cut.type, USER_TYPE.WEB_SESSION);
    },
  );

  test(
    'user is not web session',
    () async {
      var user = FirebaseRecipeUser(name: 'someone', id: '');
      var cut = UserEntityFirebase.from(user);
      expect(cut.type, USER_TYPE.USER);
    },
  );

  test(
    'create a user',
    () async {
      var user = FirebaseRecipeUser(name: 'someone', id: '1234');
      var cut = UserEntityFirebase.from(user);
      expect(cut.name, 'someone');
      expect(cut.id, '1234');
    },
  );
}
