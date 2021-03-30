import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:mockito/mockito.dart';

class MealPlanManagerMock extends Mock implements MealPlanManager {
  final Map<String, MealPlanCollectionEntity> _collections = {};
  String? _currentCollection;
  final Map<String, MealPlanEntity> _mealPlans = {};

  @override
  String? get currentCollection => this._currentCollection;

  @override
  set currentCollection(String? value) => _currentCollection = value;

  @override
  Future<MealPlanEntity> getMealPlanByCollectionID(String id) {
    // if the meal plan for the given id does not exist, create it (same behavior as actual firebase implementation)
    return Future.value(
        this._mealPlans[id] ?? MutableMealPlan.of(id, 'id', [], 2));
  }

  void addMealPlan(String group, MealPlanEntity entity) {
    this._mealPlans.putIfAbsent(group, () => entity);
  }

  @override
  Future<MealPlanCollectionEntity> createCollection(String name) {
    var doc = FirebaseMealPlanCollection(name: name, users: {'this': 'owner'});
    doc.documentID = name;
    var entity = MealPlanCollectionEntityFirebase.of(doc);
    this._collections.putIfAbsent(name, () => entity);
    return Future.value(entity);
  }

  @override
  Future<List<MealPlanCollectionEntity>> get collections =>
      Future.value(this._collections.values.toList());

  @override
  Stream<List<MealPlanCollectionEntity>> get collectionsAsStream =>
      Stream.fromFuture(Future.value(this._collections.values.toList()));

  @override
  Future<MealPlanCollectionEntity> getCollectionByID(String id) {
    return Future.value(_collections[id]);
  }

  @override
  Future<MealPlanEntity> get mealPlan {
    return this.getMealPlanByCollectionID(this.currentCollection!);
  }

  @override
  Future<void> saveMealPlan(MealPlanEntity entity) {
    assert(entity.groupID.isNotEmpty);
    if (this._mealPlans.containsKey(entity.groupID)) {
      this._mealPlans.update(entity.groupID, (value) => entity);
    } else {
      this._mealPlans.putIfAbsent(entity.groupID, () => entity);
    }
    return Future.value();
  }

  void reset() {
    _mealPlans.clear();
    _collections.clear();
    _currentCollection = null;
  }
}
