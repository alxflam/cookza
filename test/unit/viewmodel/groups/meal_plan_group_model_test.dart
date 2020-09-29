import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/viewmodel/groups/meal_plan_group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/meal_plan_manager_mock.dart';

var mock = MealPlanManagerMock();

MealPlanCollectionEntityFirebase createGroup() {
  var collection = FirebaseMealPlanCollection(
      users: {'1234': 'Someone'},
      name: 'Test',
      creationTimestamp: Timestamp.now());
  return MealPlanCollectionEntityFirebase.of(collection);
}

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<MealPlanManager>(mock);
  });

  test('Create viewmodel', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();

    var cut = MealPlanGroupViewModel.of(entity);
    var members = await cut.members();
    expect(cut.name, 'Test');
    expect(members.length, 1);
    expect(cut.entity, entity);
  });

  test('Rename group', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();

    var cut = MealPlanGroupViewModel.of(entity);
    await cut.rename('new');
    expect(cut.name, 'new');
  });

  test('Delete group', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();

    var cut = MealPlanGroupViewModel.of(entity);
    await cut.delete();
    verify(mock.deleteCollection(entity));
  });

  test('Leave group', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();

    var cut = MealPlanGroupViewModel.of(entity);
    await cut.leaveGroup();
    verify(mock.leaveGroup(entity));
  });

  test('Add user', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();

    var cut = MealPlanGroupViewModel.of(entity);
    await cut.addUser('1234', 'Master Tester');
    verify(mock.addUserToCollection(entity, '1234', 'Master Tester'));
  });
}
