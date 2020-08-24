import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/service_locator.dart';

abstract class RecipeManager {
  Future<List<RecipeCollectionEntity>> get collections;
  Stream<List<RecipeCollectionEntity>> get collectionsAsStream;

  Stream<List<RecipeEntity>> get recipes;
  Future<RecipeCollectionEntity> collectionByID(String id);

  String get currentCollection;
  set currentCollection(String id);

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

  Future<void> updateRating(RecipeEntity recipe, int rating);

  Future<void> importRecipes(List<RecipeEntity> recipes);

  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity);
}

// todo: extract an interface for the FirebaseProvider and use it also for local storage provider if that is needed
class RecipeManagerFirebase implements RecipeManager {
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
  String get currentCollection {
    return sl.get<FirebaseProvider>().currentRecipeGroup;
  }

  @override
  set currentCollection(String id) {
    return sl.get<FirebaseProvider>().setCurrentRecipeGroup(id);
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

    return sl.get<FirebaseProvider>().recipes();
  }

  @override
  Future<void> renameCollection(
      String name, RecipeCollectionEntity collection) {
    return sl.get<FirebaseProvider>().renameRecipeCollection(name, collection);
  }

  @override
  Future<void> deleteCollection(RecipeCollectionEntity entity) async {
    var firebase = sl.get<FirebaseProvider>();
    var collection = await firebase.recipeCollectionByID(entity.id);
    if (collection.users.where((e) => e.id != firebase.userUid).isNotEmpty) {
      throw '§Can\'t delete a group with members';
    }
    return firebase.deleteRecipeCollection(entity.id);
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
  Future<void> updateRating(RecipeEntity recipe, int rating) {
    return sl.get<FirebaseProvider>().updateRating(recipe, rating);
  }

  @override
  Future<void> importRecipes(List<RecipeEntity> recipes) async {
    for (var recipe in recipes) {
      // first create the recipe
      MutableRecipe entity = MutableRecipe.of(recipe);
      if (entity.hasInMemoryImage) {
        entity.image = 'true';
      }
      var ids = await sl.get<FirebaseProvider>().importRecipes([entity]);
      if (recipe.hasInMemoryImage) {
        // then upload the image if there is an in memory image
        sl
            .get<ImageManager>()
            .uploadRecipeImageFromBytes(ids.first.id, recipe.inMemoryImage);
        // update image reference field on recipe (to optimize network calls - only try to  fetch image if recipe has an image)
        sl
            .get<FirebaseProvider>()
            .updateImageReference(ids.first.id, ids.first.id);
      }
    }

    return;
  }

  @override
  Future<void> leaveRecipeGroup(RecipeCollectionEntity entity) {
    return sl.get<FirebaseProvider>().leaveRecipeGroup(entity.id);
  }
}
