import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookly/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'owner',
    () async {
      var collection = FirebaseMealPlanCollection(
          users: {'1234': 'Someone'},
          name: 'name',
          creationTimestamp: Timestamp.now());
      var cut = MealPlanCollectionEntityFirebase.of(collection);
      expect(cut.users.length, 1);
      expect(cut.users.first.id, '1234');
      expect(cut.users.first.name, 'Someone');
    },
  );

  test(
    'fields',
    () async {
      var createdAt = Timestamp.now();
      var collection = FirebaseMealPlanCollection(
          users: {'1234': 'Someone'},
          name: 'name',
          creationTimestamp: createdAt);
      collection.documentID = 'SomeID';
      var cut = MealPlanCollectionEntityFirebase.of(collection);
      expect(cut.name, 'name');
      expect(cut.creationTimestamp, createdAt.toDate());
    },
  );
}
