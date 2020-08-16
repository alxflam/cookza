import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/entities/firebase/recipe_collection_entity.dart';
import 'package:cookly/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Collection with single user',
    () async {
      var createdAt = Timestamp.now();
      var collection = FirebaseRecipeCollection(
          name: 'name',
          creationTimestamp: createdAt,
          users: {'1234': 'Someone'});

      var cut = RecipeCollectionEntityFirebase.of(collection);

      expect(cut.name, 'name');
      expect(cut.creationTimestamp, createdAt.toDate());
      expect(cut.users.length, 1);
      expect(cut.users.first.name, 'Someone');
      expect(cut.users.first.id, '1234');
    },
  );
}
