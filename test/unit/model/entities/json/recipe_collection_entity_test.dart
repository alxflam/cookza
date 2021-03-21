import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/json/recipe_collection_entity.dart';
import 'package:cookza/model/json/recipe_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Create Recipe Collection',
    () async {
      var timestamp = Timestamp.now();
      var cut = RecipeCollectionEntityJson.of(
          RecipeCollection(id: 'ID', name: 'Test'));

      expect(cut.id, 'ID');
      expect(cut.creationTimestamp, timestamp.toDate());
      expect(cut.name, 'Test');
      expect(cut.users.length, 0);
    },
  );
}
