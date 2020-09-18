import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/json/recipe_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Create collection from json', () async {
    var now = Timestamp.now();
    var json = {
      'id': '1234',
      'name': 'Ice',
      'creationTimestamp': now,
    };
    var cut = RecipeCollection.fromJson(json);

    expect(cut.name, 'Ice');
    expect(cut.id, '1234');
    expect(cut.creationTimestamp, now);
  });

  test('Collection to json', () async {
    var now = Timestamp.now();
    var json = {
      'id': '1234',
      'name': 'Ice',
      'creationTimestamp': now,
    };
    var cut = RecipeCollection.fromJson(json);
    var actual = cut.toJson();

    expect(actual, json);
  });
}
