import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/viewmodel/groups/meal_plan_group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/shared_mocks.mocks.dart';

var mock = MockMealPlanManager();

MealPlanCollectionEntityFirebase createGroup() {
  var collection = FirebaseMealPlanCollection(
    users: {'1234': 'Someone'},
    name: 'Test',
  );
  collection.documentID = '1';
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

  test('Remove user', () async {
    MealPlanCollectionEntityFirebase entity = createGroup();
    when(mock.getCollectionByID(any)).thenAnswer((_) => Future.value(entity));

    var cut = MealPlanGroupViewModel.of(entity);

    var user = UserEntityJson.from(
        JsonUser(id: '1234', name: 'Master Tester', type: USER_TYPE.USER));
    await cut.removeMember(user);
    verify(mock.removeMember(any, any));
  });
}
