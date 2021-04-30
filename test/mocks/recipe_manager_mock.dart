import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/recipe_collection_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/recipe_collection.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:collection/collection.dart';

import '../utils/id_gen.dart';

class RecipeManagerStub implements RecipeManager {
  @override
  String? currentCollection = '';

  List<RecipeCollectionEntity> _collections = [];
  final List<RecipeEntity> _recipes = [];

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
    return Future.value(_collections.firstWhereOrNull((e) => e.id == id));
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
    ));
    this._collections.add(result);
    return Future.value(result);
  }

  @override
  Future<String> createOrUpdate(RecipeEntity recipe) {
    if (recipe is MutableRecipe) {
      recipe.id ??= '1234';
    }

    /// if it's an update, remove the old entity
    _recipes.removeWhere((e) => e.id == recipe.id);

    /// then add the entity
    _recipes.add(recipe);
    return Future.value(recipe.id ?? 'id'); // always return a non null value
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
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> getRecipeById(List<String> ids) {
    return Future.value(_recipes.where((a) => ids.contains(a.id)).toList());
  }

  @override
  Future<void> importRecipes(List<RecipeEntity> recipes) {
    throw UnimplementedError();
  }

  @override
  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity) {
    throw UnimplementedError();
  }

  @override
  Stream<List<RecipeEntity>> get recipes =>
      Stream.fromFuture(Future.value(this._recipes));

  @override
  Future<void> renameCollection(
      String name, RecipeCollectionEntity collection) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateRating(RecipeEntity recipe, int rating) {
    return Future.value();
  }

  @override
  Future<void> removeMember(UserEntity user, String group) {
    throw UnimplementedError();
  }

  @override
  Future<RecipeManager> init() {
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> getFavoriteRecipes() {
    return Future.value([]);
  }

  @override
  Future<int> getRating(RecipeEntity recipe) {
    return Future.value(0);
  }

  @override
  Future<Map<String, int>> getRatings() {
    return Future.value({});
  }

  @override
  int? getCachedRating(RecipeEntity recipe) {
    return 0;
  }
}
