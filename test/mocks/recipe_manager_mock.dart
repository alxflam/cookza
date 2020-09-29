import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/recipe_collection_entity.dart';
import 'package:cookza/model/json/recipe_collection.dart';
import 'package:cookza/services/util/id_gen.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:mockito/mockito.dart';

class RecipeManagerMock extends Mock implements RecipeManager {}

class RecipeManagerStub implements RecipeManager {
  @override
  String currentCollection;

  List<RecipeCollectionEntity> _collections = [];
  List<RecipeEntity> _recipes = [];

  void reset() {
    this._recipes.clear();
    this._collections.clear();
  }

  set collectionsAsList(List<RecipeCollectionEntity> value) =>
      this._collections = value;

  @override
  Future<void> addUserToCollection(
      RecipeCollectionEntity model, String userID, String name) {
    throw UnimplementedError();
  }

  @override
  Future<RecipeCollectionEntity> collectionByID(String id) {
    return Future.value(
        _collections.firstWhere((e) => e.id == id, orElse: () => null));
  }

  @override
  Future<List<RecipeCollectionEntity>> get collections =>
      Future.value(this._collections);

  @override
  Stream<List<RecipeCollectionEntity>> get collectionsAsStream {
    return Stream.fromFuture(Future.value(this._collections));
  }

  @override
  Future<RecipeCollectionEntity> createCollection(String name) {
    var result = RecipeCollectionEntityJson.of(RecipeCollection(
        id: UniqueKeyIdGenerator().id,
        name: name,
        creationTimestamp: Timestamp.now()));
    this._collections.add(result);
    return Future.value(result);
  }

  @override
  Future<String> createOrUpdate(RecipeEntity recipe) {
    /// if it's an update, remove the old entity
    _recipes.removeWhere((e) => e.id == recipe.id);

    /// then add the entity
    _recipes.add(recipe);
    return Future.value(recipe.id);
  }

  @override
  Future<void> deleteCollection(RecipeCollectionEntity model) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecipe(RecipeEntity recipe) {
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> getAllRecipes() {
    return Future.value(this._recipes);
  }

  @override
  String getNextRecipeDocumentId(String recipeGroup) {
    // TODO: implement getNextRecipeDocumentId
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> getRecipeById(List<String> ids) {
    return Future.value(_recipes.where((a) => ids.contains(a.id)).toList());
  }

  @override
  Future<void> importRecipes(List<RecipeEntity> recipes) {
    // TODO: implement importRecipes
    throw UnimplementedError();
  }

  @override
  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity) {
    // TODO: implement leaveRecipeGroup
    throw UnimplementedError();
  }

  @override
  Stream<List<RecipeEntity>> get recipes =>
      Stream.fromFuture(Future.value(this._recipes));

  @override
  Future<void> renameCollection(
      String name, RecipeCollectionEntity collection) {
    // TODO: implement renameCollection
    throw UnimplementedError();
  }

  @override
  Future<void> updateRating(RecipeEntity recipe, int rating) {
    // TODO: implement updateRating
    throw UnimplementedError();
  }

  @override
  Future<void> removeMember(UserEntity user, String group) {
    // TODO: implement removeMember
    throw UnimplementedError();
  }
}
