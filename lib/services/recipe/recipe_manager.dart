import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';

abstract class RecipeManager {
  Future<List<RecipeCollectionEntity>> get collections;
  Stream<List<RecipeCollectionEntity>> get collectionsAsStream;

  Stream<List<RecipeEntity>> get recipes;
  Future<RecipeCollectionEntity> collectionByID(String id);

  String? get currentCollection;
  set currentCollection(String? id);

  Future<RecipeCollectionEntity> createCollection(String name);

  Future<String> createOrUpdate(RecipeEntity recipe);

  Future<void> renameCollection(String name, RecipeCollectionEntity collection);

  Future<void> deleteCollection(RecipeCollectionEntity model);

  Future<void> addUserToCollection(
      RecipeCollectionEntity model, String userID, String name);

  String getNextRecipeDocumentId(String recipeGroup);

  Future<void> deleteRecipe(RecipeEntity recipe);

  Future<List<RecipeEntity>> getAllRecipes();

  Future<List<RecipeEntity>> getRecipeById(List<String> ids);

  Future<List<RecipeEntity>> getFavoriteRecipes();

  Future<void> updateRating(RecipeEntity recipe, int rating);

  Future<Map<String, int>> getRatings();

  Future<int> getRating(RecipeEntity recipe);

  int? getCachedRating(RecipeEntity recipe);

  Future<void> importRecipes(List<RecipeEntity> recipes);

  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity);

  Future<void> removeMember(UserEntity user, String group);

  Future<void> init();
}

class RecipeManagerFirebase implements RecipeManager {
  /// the currently selected collection
  /// stored as a shared preference to reuse the LRU collection upon
  /// restart of the app
  String? _currentCollection;
  final Map<String, int> _ratings = {};

  /// whether ratigns have been fetched from firestore
  bool _ratingsInitialized = false;

  @override
  Future<List<RecipeCollectionEntity>> get collections async {
    return await sl.get<FirebaseProvider>().recipeCollectionsAsList();
  }

  @override
  Stream<List<RecipeCollectionEntity>> get collectionsAsStream {
    return sl.get<FirebaseProvider>().recipeCollectionsAsStream();
  }

  @override
  Future<RecipeCollectionEntity> createCollection(String name) async {
    return await sl.get<FirebaseProvider>().createRecipeCollection(name);
  }

  @override
  Future<String> createOrUpdate(RecipeEntity recipe) async {
    return await sl.get<FirebaseProvider>().createOrUpdateRecipe(recipe);
  }

  @override
  String? get currentCollection {
    return this._currentCollection;
  }

  @override
  set currentCollection(String? id) {
    this._currentCollection = id;
    sl.get<SharedPreferencesProvider>().leastRecentlyUsedRecipeGroup = id ?? '';
  }

  @override
  Future<RecipeCollectionEntity> collectionByID(String id) async {
    return await sl.get<FirebaseProvider>().recipeCollectionByID(id);
  }

  @override
  Stream<List<RecipeEntity>> get recipes {
    if (this.currentCollection == null) {
      return Stream.empty();
    }

    return sl.get<FirebaseProvider>().recipes(this.currentCollection!);
  }

  @override
  Future<void> renameCollection(
      String name, RecipeCollectionEntity collection) {
    return sl.get<FirebaseProvider>().renameRecipeCollection(name, collection);
  }

  @override
  Future<void> deleteCollection(RecipeCollectionEntity entity) async {
    var firebase = sl.get<FirebaseProvider>();
    var collection = await firebase.recipeCollectionByID(entity.id!);
    if (collection.users.where((e) => e.id != firebase.userUid).isNotEmpty) {
      throw '§Can\'t delete a group with members';
    }
    if (this._currentCollection == entity.id) {
      this._currentCollection = null;
    }
    return firebase.deleteRecipeCollection(entity.id!);
  }

  @override
  Future<void> addUserToCollection(
      RecipeCollectionEntity model, String userID, String name) async {
    return sl.get<FirebaseProvider>().addUserToCollection(model, userID, name);
  }

  @override
  String getNextRecipeDocumentId(String recipeGroup) {
    return sl.get<FirebaseProvider>().getNextRecipeDocumentId(recipeGroup);
  }

  @override
  Future<void> deleteRecipe(RecipeEntity recipe) async {
    return await sl.get<FirebaseProvider>().deleteRecipe(recipe);
  }

  @override
  Future<List<RecipeEntity>> getAllRecipes() async {
    return await sl.get<FirebaseProvider>().getAllRecipes();
  }

  @override
  Future<List<RecipeEntity>> getRecipeById(List<String> id) async {
    return await sl.get<FirebaseProvider>().getRecipeById(id);
  }

  @override
  Future<Map<String, int>> getRatings() async {
    if (!_ratingsInitialized) {
      final ratings = await sl.get<FirebaseProvider>().getRatings();
      for (var item in ratings) {
        this._ratings.update(item.recipeId, (value) => item.rating,
            ifAbsent: () => item.rating);
      }
      _ratingsInitialized = true;
    }

    return Future.value(this._ratings);
  }

  @override
  Future<List<RecipeEntity>> getFavoriteRecipes() async {
    var ratings = await this.getRatings();
    if (ratings.isEmpty) {
      return Future.value([]);
    } else {
      final recipes =
          await sl.get<FirebaseProvider>().getRecipeById(ratings.keys.toList());
      recipes.sort((a, b) {
        final ratingA = this._ratings[a.id] ?? 0;
        final ratingB = this._ratings[b.id] ?? 0;
        return ratingB.compareTo(ratingA);
      });
      return recipes;
    }
  }

  @override
  Future<void> updateRating(RecipeEntity recipe, int rating) {
    this._ratings.update(recipe.id!, (value) => rating, ifAbsent: () => rating);
    return sl.get<FirebaseProvider>().updateRating(recipe, rating);
  }

  @override
  Future<int> getRating(RecipeEntity recipe) async {
    var cached = getCachedRating(recipe);
    if (cached != null) {
      return cached;
    }

    /// update cache of ratings
    await getRatings();
    cached = this._ratings[recipe.id];
    return cached ?? 0;
  }

  @override
  int? getCachedRating(RecipeEntity recipe) {
    return this._ratings[recipe.id];
  }

  @override
  Future<void> importRecipes(List<RecipeEntity> recipes) async {
    if (this.currentCollection == null) {
      throw 'A collection needs to be set for import';
    }

    for (var recipe in recipes) {
      // first create the recipe
      MutableRecipe entity = MutableRecipe.of(recipe);
      if (entity.hasInMemoryImage) {
        entity.image = 'true';
      }
      var ids = await sl
          .get<FirebaseProvider>()
          .importRecipes([entity], this.currentCollection!);
      if (recipe.hasInMemoryImage) {
        // then upload the image if there is an in memory image
        await sl
            .get<ImageManager>()
            .uploadRecipeImageFromBytes(ids.first.id!, recipe.inMemoryImage!);
        // update image reference field on recipe (to optimize network calls - only try to  fetch image if recipe has an image)
        await sl
            .get<FirebaseProvider>()
            .updateImageReference(ids.first.id!, ids.first.id!);
      }
    }

    return;
  }

  @override
  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity) {
    if (this._currentCollection == entity.id) {
      this._currentCollection = null;
    }
    return sl.get<FirebaseProvider>().leaveRecipeGroup(entity.id!);
  }

  @override
  Future<void> removeMember(UserEntity user, String group) {
    return sl.get<FirebaseProvider>().removeFromRecipeGroup(user, group);
  }

  @override
  Future<void> init() {
    var collection =
        sl.get<SharedPreferencesProvider>().getLeastRecentlyUsedRecipeGroup();
    if (collection != null && collection.isNotEmpty) {
      this.currentCollection = collection;
    }
    return Future.value(this._currentCollection);
  }
}
