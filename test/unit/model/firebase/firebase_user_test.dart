import 'package:cookza/model/firebase/general/firebase_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse User from JSON',
    () async {
      var json = {
        'name': 'John Doe',
        'id': '7777',
      };

      var cut = FirebaseRecipeUser.fromJson(json, id: '1234');

      expect(cut.documentID, '1234');
      expect(cut.id, '7777');
      expect(cut.name, 'John Doe');
    },
  );

  test(
    'User to JSON',
    () async {
      var json = {
        'name': 'John Doe',
        'id': '7777',
      };

      var cut = FirebaseRecipeUser.fromJson(json, id: '1234');
      var actual = cut.toJson();

      expect(json, actual);
    },
  );
}
