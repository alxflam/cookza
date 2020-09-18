import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookly/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse Recipe Collection from JSON',
    () async {
      var now = Timestamp.now();
      var users = {'4567': 'ABC', '007': 'James Bond'};
      var json = {
        'name': 'Test',
        'creationTimestamp': now,
        'users': users,
      } as Map<String, dynamic>;

      var cut = FirebaseRecipeCollection.fromJson(json, '1234');

      expect(cut.documentID, '1234');
      expect(cut.name, 'Test');
      expect(cut.users.length, 2);
      expect(cut.users, users);
    },
  );

  test(
    'Parse Recipe Collection from JSON',
    () async {
      var now = Timestamp.now();
      var users = {'4567': 'ABC', '007': 'James Bond'};
      var json = {
        'name': 'Test',
        'creationTimestamp': now,
        'users': users,
      } as Map<String, dynamic>;

      var cut = FirebaseRecipeCollection.fromJson(json, '1234');
      var actual = cut.toJson();
      expect(json, actual);
    },
  );
}
