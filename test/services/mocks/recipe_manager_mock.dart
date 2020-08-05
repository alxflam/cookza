import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/services/recipe_manager.dart';

class RecipeManagerMock implements RecipeManager {
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
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeCollectionEntity>> get collections =>
      Future.value(this._collections);

  @override
  Stream<List<RecipeCollectionEntity>> get collectionsAsStream =>
      throw UnimplementedError();

  @override
  Future<RecipeCollectionEntity> createCollection(String name) {
    throw UnimplementedError();
  }

  @override
  Future<String> createOrUpdate(RecipeEntity recipe) {
    _recipes.add(recipe);
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
    // TODO: implement getRecipeById
    throw UnimplementedError();
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
  // TODO: implement recipes
  Stream<List<RecipeEntity>> get recipes => throw UnimplementedError();

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
}
