import 'package:cookza/model/entities/firebase/user_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/model/firebase/general/firebase_user.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/firebase.dart';

void main() {
  setUp(() async {
    await mockFirestore();
  });

  test('Create collection', () async {
    var cut = MealPlanManagerFirebase();

    await cut.createCollection('Test');

    var collections = await cut.collections;

    expect(collections.first.name, 'Test');
  });

  test('Delete collection', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.deleteCollection(group);

    var collections = await cut.collections;

    expect(collections, isEmpty);
  });

  test('Delete collection resets current collection if current got deleted',
      () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');
    cut.currentCollection = group.id!;

    await cut.deleteCollection(group);
    var collections = await cut.collections;

    expect(collections, isEmpty);
    expect(cut.currentCollection, isNull);
  });

  test('Rename collection', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.renameCollection('Cheese', group);

    var collections = await cut.collections;

    expect(collections.first.name, 'Cheese');
    expect(collections.length, 1);
  });

  test('Collections as stream', () async {
    var cut = MealPlanManagerFirebase();

    await cut.createCollection('Test');

    var collections = cut.collectionsAsStream;

    expect(collections, isNotNull);
  });

  test('Set and get current collection', () async {
    var cut = MealPlanManagerFirebase();

    var group = cut.currentCollection;
    expect(group, isNull);

    cut.currentCollection = '1';
    group = cut.currentCollection;
    expect(group, '1');
  });

  test('Add user to group', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.addUserToCollection(group, '42', 'Tux');

    var collection = await cut.getCollectionByID(group.id!);

    expect(collection.users.last.name, 'Tux');
  });

  test('Remove user from group', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.addUserToCollection(group, '42', 'Tux');
    var collection = await cut.getCollectionByID(group.id!);
    expect(collection.users.last.name, 'Tux');

    await cut.removeMember(
        UserEntityFirebase.from(FirebaseRecipeUser(name: 'Tux', id: '42')),
        group.id!);
    collection = await cut.getCollectionByID(group.id!);

    /// only the auto generated owner entry is now present
    expect(collection.users.last.name, 'owner');
  });

  test('Leave group', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.leaveGroup(group);
    var collections = await cut.collections;

    expect(collections, isEmpty);
    var currentCollection = cut.currentCollection;
    expect(currentCollection, isNull);
  });

  test('Save meal plan', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');
    var plan = MutableMealPlan.of(null, group.id!, [], 2);

    await cut.saveMealPlan(plan);

    var planByManager = await cut.getMealPlanByCollectionID(group.id!);
    expect(planByManager, isNotNull);
  });

  test('Update meal plan', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');
    var plan = MutableMealPlan.of(null, group.id!, [], 2);

    await cut.saveMealPlan(plan);

    var planByManager = await cut.getMealPlanByCollectionID(group.id!);
    expect(planByManager, isNotNull);
    expect(planByManager?.items, isEmpty);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'Test', 0));
    plan.items.add(item);
    await cut.saveMealPlan(plan);

    planByManager = await cut.getMealPlanByCollectionID(group.id!);
    expect(planByManager, isNotNull);
    expect(planByManager?.items.length, 1);
  });

  test('Get current meal plan', () async {
    var cut = MealPlanManagerFirebase();

    var plan = await cut.mealPlan;
    expect(plan, isNull);

    var group = await cut.createCollection('Test');
    cut.currentCollection = group.id;

    plan = await cut.mealPlan;
    expect(plan, isNotNull);

    var entity = MutableMealPlan.of(null, group.id!, [], 2);
    await cut.saveMealPlan(entity);

    plan = await cut.mealPlan;
    expect(plan, isNotNull);
  });

  test('Get meal plan by id', () async {
    var cut = MealPlanManagerFirebase();

    var group = await cut.createCollection('Test');
    cut.currentCollection = group.id;

    var plan = MutableMealPlan.of(null, group.id!, [], 2);
    await cut.saveMealPlan(plan);

    var savedPlan = await cut.getMealPlanByCollectionID(group.id!);
    expect(savedPlan, isNotNull);

    savedPlan = await cut.getMealPlanByCollectionID('I-do-not-exist');
    expect(savedPlan, isNull);
  });
}
