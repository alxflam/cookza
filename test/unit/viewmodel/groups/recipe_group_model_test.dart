import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/recipe_collection_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/groups/recipe_group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/shared_mocks.mocks.dart';

var mock = MockRecipeManager();

RecipeCollectionEntityFirebase createGroup() {
  var collection = FirebaseRecipeCollection(
      users: {'1234': 'Someone'},
      name: 'Test',
      creationTimestamp: Timestamp.now());
  collection.documentID = '123456789';
  return RecipeCollectionEntityFirebase.of(collection);
}

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<RecipeManager>(mock);
  });

  test('Create viewmodel', () async {
    RecipeCollectionEntityFirebase entity = createGroup();

    var cut = RecipeGroupViewModel.of(entity);
    var members = await cut.members();
    expect(cut.name, 'Test');
    expect(members.length, 1);
    expect(cut.entity, entity);
  });

  test('Rename group', () async {
    RecipeCollectionEntityFirebase entity = createGroup();

    var cut = RecipeGroupViewModel.of(entity);
    await cut.rename('new');
    expect(cut.name, 'new');
  });

  test('Delete group', () async {
    RecipeCollectionEntityFirebase entity = createGroup();

    var cut = RecipeGroupViewModel.of(entity);
    await cut.delete();
    verify(mock.deleteCollection(entity));
  });

  test('Leave group', () async {
    RecipeCollectionEntityFirebase entity = createGroup();

    var cut = RecipeGroupViewModel.of(entity);
    await cut.leaveGroup();
    verify(mock.leaveRecipeGroup(entity));
  });

  test('Add user', () async {
    RecipeCollectionEntityFirebase entity = createGroup();

    var cut = RecipeGroupViewModel.of(entity);
    await cut.addUser('1234', 'Master Tester');
    verify(mock.addUserToCollection(entity, '1234', 'Master Tester'));
  });

  test('Remove user', () async {
    RecipeCollectionEntityFirebase entity = createGroup();
    when(mock.collectionByID(any)).thenAnswer((_) => Future.value(entity));

    var cut = RecipeGroupViewModel.of(entity);
    await cut.addUser('1234', 'Master Tester');

    var user = UserEntityJson.from(
        JsonUser(id: '1234', name: 'Master Tester', type: USER_TYPE.USER));
    await cut.removeMember(user);
    verify(mock.removeMember(any, any));
  });
}
