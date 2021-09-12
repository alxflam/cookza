import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/abstract/rating_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_group_entity.dart';
import 'package:cookza/model/entities/firebase/instruction_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookza/model/entities/firebase/rating_entity.dart';
import 'package:cookza/model/entities/firebase/recipe_collection_entity.dart';
import 'package:cookza/model/entities/firebase/recipe_entity.dart';
import 'package:cookza/model/entities/firebase/shopping_list_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookza/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookza/model/firebase/general/firebase_handshake.dart';
import 'package:cookza/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookza/model/firebase/recipe/firebase_instruction.dart';
import 'package:cookza/model/firebase/recipe/firebase_rating.dart';
import 'package:cookza/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookza/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/web/web_login_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

const RECIPE_GROUPS = 'recipeGroups';
const INGREDIENTS = 'ingredients';
const INSTRUCTIONS = 'instructions';
const RECIPES = 'recipes';
const RATINGS = 'ratings';
const MEAL_PLAN_GROUPS = 'mealPlanGroups';
const MEAL_PLANS = 'mealPlans';
const SHOPPING_LISTS = 'shoppingLists';
const HANDSHAKES = 'handshakes';

class FirebaseProvider {
  final FirebaseAuth _auth = sl.get<FirebaseAuth>();
  final FirebaseFirestore _firestore = sl.get<FirebaseFirestore>();
  final log = Logger('FirebaseProvider');

  User? _currentUser;
  String? ownerUserId;

  bool isLoggedIn() {
    return _currentUser != null;
  }

  /// returns the UID assigned to the currently logged in user
  String get userUid {
    return _currentUser!.uid;
  }

  Future<void> signOut() async {
    ownerUserId = null;
    _currentUser = null;
    await this._auth.signOut();
  }

  Stream<List<MealPlanCollectionEntity>> get mealPlanGroups {
    return _mealPlanGroupsQuery().snapshots().map((e) => e.docs
        .where((e) => e.exists)
        .map((e) => MealPlanCollectionEntityFirebase.of(
            FirebaseMealPlanCollection.fromJson(e.data(), e.id)))
        .toList());
  }

  Future<List<ShoppingListEntity>> get shoppingListsAsList async {
    var groups = (await mealPlanGroupsAsList)
        .where((a) => a.id != null)
        .map((e) => e.id!)
        .toList();
    if (groups.isEmpty) {
      return Future.value([]);
    }
    var docs = await _shoppingListsSnapshots(groups);

    return docs
        .map((e) => e.docs)
        .expand((e) => e)
        .map((e) => ShoppingListEntityFirebase.of(
            FirebaseShoppingListDocument.fromJson(e.data(), e.id)))
        .toList();
  }

  Future<List<QueryDocumentSnapshot>> getShoppingListsByMealPlan(
      String mealPlan) async {
    var docs = await _shoppingListsSnapshots([mealPlan]);
    return docs.map((e) => e.docs).expand((e) => e).toList();
  }

  Query<Map<String, dynamic>> _mealPlanGroupsQuery() {
    return _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '');
  }

  Future<List<QuerySnapshot<Map<String, dynamic>>>> _shoppingListsSnapshots(
      List<String> groups) async {
    final collection = _firestore.collection(SHOPPING_LISTS);
    final docRefs =
        groups.map((e) => collection.where('groupID', isEqualTo: e)).toList();
    // instead of a whereIn clause resolve documents individually as the in clause can only handle up to max. 10 items
    final snapshots = await Future.wait(docRefs.map((e) => e.get()));

    return snapshots;
  }

  Future<List<MealPlanCollectionEntity>> get mealPlanGroupsAsList async {
    var docs = await _mealPlanGroupsQuery().get();

    return docs.docs
        .map((e) => MealPlanCollectionEntityFirebase.of(
            FirebaseMealPlanCollection.fromJson(e.data(), e.id)))
        .toList();
  }

  /// create a new recipe collection
  Future<MealPlanCollectionEntityFirebase> createMealPlanGroup(
      String name) async {
    var document = await _firestore.collection(MEAL_PLAN_GROUPS).add(
          FirebaseMealPlanCollection(
            name: name,
            users: await _getCreationUsersMap(),
          ).toJson(),
        );
    var model = await document.get();
    log.info('created meal plan collection ${document.id}');

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(model.data()!, model.id));
  }

  Future<void> renameMealPlanCollection(
      String name, MealPlanCollectionEntity entity) async {
    return _firestore
        .collection(MEAL_PLAN_GROUPS)
        .doc(entity.id)
        .set({'name': name}, SetOptions(merge: true));
  }

  /// retrieve all recipe collections the user can access
  Future<List<MealPlanCollectionEntity>> mealPlanCollectionsAsList() async {
    var docs = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    return docs.docs
        .map((e) => MealPlanCollectionEntityFirebase.of(
            FirebaseMealPlanCollection.fromJson(e.data(), e.id)))
        .toList();
  }

  /// initialize firebase connection by ensuring the user is logged in
  Future<FirebaseProvider> init() async {
    if (kIsWeb) {
      // don't reuse cached sessions on web
      var user = _auth.currentUser;
      if (user != null) {
        await _auth.signOut();
      }
      return this;
    }

    _currentUser = _auth.currentUser;
    if (_currentUser == null) {
      // TODO catch FirebaseException if device is offline, better check for connection beforehand!
      await signInAnonymously();
    }
    ownerUserId = _currentUser?.uid;

    log.info('logged in anonymously using token ${_currentUser?.uid}');

    return this;
  }

  Future<void> signInAnonymously() async {
    var result = await _auth.signInAnonymously();
    _currentUser = result.user;
  }

  /// create a new recipe collection
  Future<RecipeCollectionEntity> createRecipeCollection(String name) async {
    var document = await _firestore.collection(RECIPE_GROUPS).add(
          FirebaseRecipeCollection(
            name: name,
            creationTimestamp: Timestamp.now(),
            users: await _getCreationUsersMap(),
          ).toJson(),
        );
    var model = await document.get();
    log.info('created recipe collection ${document.id}');

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(model.data()!, model.id));
  }

  Future<void> renameRecipeCollection(
      String name, RecipeCollectionEntity entity) async {
    return _firestore
        .collection(RECIPE_GROUPS)
        .doc(entity.id)
        .set({'name': name}, SetOptions(merge: true));
  }

  /// retrieve all recipe collections the user can access
  Future<List<RecipeCollectionEntity>> recipeCollectionsAsList() async {
    var docs = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    return docs.docs
        .map((e) => RecipeCollectionEntityFirebase.of(
            FirebaseRecipeCollection.fromJson(e.data(), e.id)))
        .toList();
  }

  Stream<List<RecipeCollectionEntity>> recipeCollectionsAsStream() {
    return _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .snapshots()
        .map((e) => e.docs
            .map((e) => RecipeCollectionEntityFirebase.of(
                FirebaseRecipeCollection.fromJson(e.data(), e.id)))
            .toList());
  }

  /// todo: option to get all or only from a specific recipe group
  Stream<List<RecipeEntity>> recipes(String groupId) {
    return _firestore
        .collection(RECIPES)
        .where('recipeGroupID', isEqualTo: groupId)
        .orderBy('name')
        .snapshots()
        .map((e) => e.docs
            .map((e) => RecipeEntityFirebase.of(
                FirebaseRecipe.fromJson(e.data(), id: e.id)))
            .toList());
  }

  Future<String> createOrUpdateRecipe(RecipeEntity recipe) async {
    if (recipe.id != null) {
      return _updateRecipe(recipe);
    }
    return _createRecipe(recipe);
  }

  Future<String> _createRecipe(RecipeEntity recipe) async {
    var baseRecipe = FirebaseRecipe.from(recipe);
    var ingredientGroups = await FirebaseIngredientGroup.from(recipe);

    var instructions = await FirebaseInstruction.from(recipe);

    // using batch instead of transaction as it should be possible to create recipes in offline mode
    var recipeDocRef = _firestore.collection(RECIPES).doc();

    var ingredientsDocRef =
        _firestore.collection(INGREDIENTS).doc(recipeDocRef.id);

    var instructionsDocRef =
        _firestore.collection(INSTRUCTIONS).doc(recipeDocRef.id);

    baseRecipe.documentID = recipeDocRef.id;
    baseRecipe.ingredientsID = ingredientsDocRef.id;
    baseRecipe.instructionsID = instructionsDocRef.id;

    var batch = _firestore.batch();
    batch.set(recipeDocRef, baseRecipe.toJson());

    var ingredientsDoc =
        FirebaseIngredientDocument.from([], recipeDocRef.id, ingredientGroups);

    batch.set(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.id);

    batch.set(instructionsDocRef, instructionsDoc.toJson());

    await batch.commit();

    return recipeDocRef.id;
  }

  Future<String> _updateRecipe(RecipeEntity recipe) async {
    var baseRecipe = FirebaseRecipe.from(recipe);
    var instructions = await FirebaseInstruction.from(recipe);
    var ingredientGroups = await FirebaseIngredientGroup.from(recipe);

    var recipeDocRef = _firestore.collection(RECIPES).doc(recipe.id);

    var batch = _firestore.batch();
    batch.set(recipeDocRef, baseRecipe.toJson());

    var ingredientsDoc =
        FirebaseIngredientDocument.from([], recipeDocRef.id, ingredientGroups);

    var ingredientsDocRef =
        _firestore.collection(INGREDIENTS).doc(recipeDocRef.id);
    batch.set(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.id);

    var instructionsDocRef =
        _firestore.collection(INSTRUCTIONS).doc(recipeDocRef.id);
    batch.set(instructionsDocRef, instructionsDoc.toJson());

    await batch.commit();

    log.info('updated recipe ${recipe.id}');

    return recipe.id!;
  }

  Future<void> deleteRecipe(RecipeEntity recipe) async {
    await _firestore.collection(RECIPES).doc(recipe.id).delete();
    log.info('deleted recipe ${recipe.id}');
  }

  Future<RecipeCollectionEntity> recipeCollectionByID(String id) async {
    var doc = await _firestore.collection(RECIPE_GROUPS).doc(id).get();

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(doc.data()!, doc.id));
  }

  Future<void> deleteRecipeCollection(String id) async {
    var collection = _firestore.collection(RECIPE_GROUPS).doc(id);

    var recipes = await _firestore
        .collection(RECIPES)
        .where('recipeGroupID', isEqualTo: id)
        .get();

    for (var recipe in recipes.docs) {
      var entity = RecipeEntityFirebase.of(
          FirebaseRecipe.fromJson(recipe.data(), id: recipe.id));
      await sl.get<ImageManager>().deleteRecipeImage(entity.id!);
    }

    await _firestore.runTransaction<int>((transaction) {
      int updates = recipes.docs.length + 1;
      for (var recipe in recipes.docs) {
        transaction.delete(recipe.reference);
      }

      transaction.delete(collection);

      return Future.value(updates);
    });
  }

  Future<int> deleteMealPlanCollection(String id) async {
    var reference = _firestore.collection(MEAL_PLAN_GROUPS).doc(id);

    var snapshot = await _firestore
        .collection(MEAL_PLANS)
        .where('groupID', isEqualTo: id)
        .limit(1)
        .get();

    var shoppingLists = await getShoppingListsByMealPlan(id);

    return _firestore.runTransaction<int>((transaction) {
      int updates = snapshot.docs.length + shoppingLists.length + 1;
      // delete the meal plan
      for (var mealPlanDoc in snapshot.docs) {
        transaction.delete(mealPlanDoc.reference);
      }
      // delete all the assigned shopping lists
      for (var shoppingList in shoppingLists) {
        transaction.delete(shoppingList.reference);
      }
      // delete the meal plan group
      transaction.delete(reference);
      return Future.value(updates);
    });
  }

  Future<void> deleteShoppingList(ShoppingListEntity entity) {
    assert(entity.id != null);
    return _firestore.collection(SHOPPING_LISTS).doc(entity.id).delete();
  }

  Future<void> addUserToCollection(
      RecipeCollectionEntity model, String newUserID, String name) async {
    var docRef = _firestore.collection(RECIPE_GROUPS).doc(model.id);

    return await docRef.update({'users.$newUserID': name});
  }

  Future<void> addUserToMealPlanCollection(
      MealPlanCollectionEntity model, String newUserID, String name) async {
    var docRef = _firestore.collection(MEAL_PLAN_GROUPS).doc(model.id);

    return await docRef.update({'users.$newUserID': name});
  }

  String getNextRecipeDocumentId(String recipeGroup) {
    var recipeDocRef = _firestore.collection(RECIPES).doc();
    return recipeDocRef.id;
  }

  Future<List<IngredientGroupEntityFirebase>> recipeIngredientGroups(
      String recipeGroup, String recipeID) async {
    var doc = await _firestore.collection(INGREDIENTS).doc(recipeID).get();

    var docData = FirebaseIngredientDocument.fromJson(doc.data()!, doc.id);

    /// if it's a legacy recipe, wrap the legacy ingredient list inside a group
    if (docData.groups?.isEmpty ?? true) {
      // ignore: deprecated_member_use_from_same_package
      if (docData.ingredients?.isNotEmpty ?? false) {
        return [
          // ignore: deprecated_member_use_from_same_package
          IngredientGroupEntityFirebase(docData.ingredients ?? [], name: '')
        ];
      }
      return [];
    }

    /// otherwise return the actual ingredient groups
    return docData.groups!
        .map((e) => IngredientGroupEntityFirebase(e.ingredients, name: e.name))
        .toList();
  }

  Future<List<RecipeEntity>> getAllRecipes() async {
    var collections = await recipeCollectionsAsList();
    if (collections.isEmpty) {
      return Future.value([]);
    }

// TODO: how to deal with max 10 whereIn items!? => sort order currently done by server query
// see getRecipesById => resolve each collection individually...

    // final collection = _firestore.collection(RECIPES);
    // final docRefs = collections.map((e) => collection.where('recipeGroupID', isEqualTo: e.id)).toList();
    // // instead of a whereIn clause resolve documents individually as the in clause can only handle up to max. 10 items
    // final snapshots = await Future.wait(docRefs.map((e) => e.get()));

    var docs = await _firestore
        .collection(RECIPES)
        .where('recipeGroupID', whereIn: collections.map((e) => e.id).toList())
        .orderBy('name')
        .get();

    log.info('all documents retrieved ${docs.docs.length} results');

    return docs.docs
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data(), id: e.id)))
        .toList();
  }

  /// Returns all ratings for the current user
  Future<List<RatingEntity>> getRatings() async {
    var docs = await _firestore
        .collection(RATINGS)
        .where('userId', isEqualTo: userUid)
        .orderBy('rating', descending: true)
        .get();

    return docs.docs
        .map((e) => RatingEntityFirebase.of(
            FirebaseRating.fromJson(e.data(), id: e.id)))
        .toList();
  }

  /// Returns the rating for a given recipe for the logged in user
  Future<RatingEntity?> getRatingById(String recipeId) async {
    var docs = await _firestore
        .collection(RATINGS)
        .where('userId', isEqualTo: userUid)
        .where('recipeId', isEqualTo: recipeId)
        .get();

    var doc = docs.docs.first;
    if (doc.exists) {
      return RatingEntityFirebase.of(
          FirebaseRating.fromJson(doc.data(), id: doc.id));
    } else {
      return Future.value(null);
    }
  }

  Future<List<RecipeEntity>> getRecipeById(List<String> ids) async {
    final collection = _firestore.collection(RECIPES);
    final docRefs = ids.map((e) => collection.doc(e)).toList();
    // instead of a whereIn clause resolve documents individually as the in clause can only handle up to max. 10 items
    final snapshots = await Future.wait(docRefs.map((e) => e.get()));

    return snapshots
        .where((e) => e.exists)
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data() ?? {}, id: e.id)))
        .toList();
  }

  Future<List<InstructionEntityFirebase>> recipeInstructions(
      String recipeGroup, String recipeID) async {
    var doc = await _firestore.collection(INSTRUCTIONS).doc(recipeID).get();

    var data = FirebaseInstructionDocument.fromJson(doc.data()!, doc.id);

    log.info('instructions received: ${data.instructions.length}');

    var result =
        data.instructions.map((e) => InstructionEntityFirebase.of(e)).toList();
    result.sort((a, b) {
      if (a.step == null || b.step == null) {
        return 0;
      }
      return a.step!.compareTo(b.step ?? 0);
    });
    return result;
  }

  Future<void> updateRating(RecipeEntity recipe, int rating) async {
    var ratingDocQuery = await _firestore
        .collection(RATINGS)
        .where('userId', isEqualTo: userUid)
        .where('recipeId', isEqualTo: recipe.id)
        .get();

    if (ratingDocQuery.docs.isNotEmpty) {
      var doc = ratingDocQuery.docs.first;
      await doc.reference.set({'rating': rating}, SetOptions(merge: true));
    } else {
      var entity =
          FirebaseRating(recipeId: recipe.id!, userId: userUid, rating: rating);
      await _firestore.collection(RATINGS).add(entity.toJson());
    }
  }

  Future<MealPlanEntity> mealPlan(String groupID) async {
    var snapshot = await _firestore
        .collection(MEAL_PLANS)
        .where('groupID', isEqualTo: groupID)
        .limit(1)
        .get();

    FirebaseMealPlanDocument parsedDoc;

    if (snapshot.docs.isEmpty) {
      parsedDoc = FirebaseMealPlanDocument.empty(this.userUid, groupID);
    } else {
      var document = snapshot.docs.first;
      parsedDoc =
          FirebaseMealPlanDocument.fromJson(document.data(), document.id);
    }

    var model = MealPlanEntityFirebase.of(parsedDoc);
    return model;
  }

  Future<String> saveMealPlan(MealPlanEntity entity) async {
    assert(entity.groupID.isNotEmpty);
    DocumentReference docRef;
    if (entity.id != null && entity.id!.isNotEmpty) {
      docRef = _firestore.collection(MEAL_PLANS).doc(entity.id);
    } else {
      // creation with same id as the corresponding group
      docRef = _firestore.collection(MEAL_PLANS).doc(entity.groupID);
    }

    var data = FirebaseMealPlanDocument.from(entity);

    await docRef.set(data.toJson());

    return docRef.id;
  }

  Future<List<RecipeEntity>> importRecipes(
      List<RecipeEntity> recipes, String groupId) async {
    List<RecipeEntity> ids = [];
    for (var recipe in recipes) {
      var target = await MutableRecipe.createFrom(recipe);
      target.id = null;
      target.recipeCollectionId = groupId;
      var id = await _createRecipe(target);
      var mutableRecipe = await MutableRecipe.createFrom(recipe);
      mutableRecipe.id = id;
      ids.add(mutableRecipe);
    }
    return ids;
  }

  Future<int> leaveMealPlanGroup(String id) async {
    return await _removeMemberFromMealPlanGroup(id, this.userUid);
  }

  Future<int> _removeMemberFromMealPlanGroup(
      String mealPlanID, String userID) async {
    var docRef = _firestore.collection(MEAL_PLAN_GROUPS).doc(mealPlanID);

    var doc = await docRef.get(const GetOptions(source: Source.server));
    var mealPlan = FirebaseMealPlanCollection.fromJson(doc.data()!, doc.id);
    var deleteMealPlan =
        mealPlan.users.entries.where((a) => a.key != userID).isEmpty;

    if (deleteMealPlan) {
      return deleteMealPlanCollection(mealPlanID);
    } else {
      return _firestore.runTransaction((transaction) {
        transaction.update(docRef, {'users.$userID': FieldValue.delete()});
        return Future.value(1);
      });
    }
  }

  Future<void> leaveRecipeGroup(String id) async {
    return await _removeMemberFromRecipeGroup(id, this.userUid);
  }

  Future<void> _removeMemberFromRecipeGroup(String groupID, userID) async {
    var docRef = _firestore.collection(RECIPE_GROUPS).doc(groupID);

    var doc = await docRef.get(const GetOptions(source: Source.server));
    var recipeGroup = FirebaseRecipeCollection.fromJson(doc.data()!, doc.id);
    var deleteGroup =
        recipeGroup.users.entries.where((a) => a.key != userID).isEmpty;

    if (deleteGroup) {
      return deleteRecipeCollection(groupID);
    } else {
      return _firestore.runTransaction((transaction) {
        transaction.update(docRef, {'users.$userID': FieldValue.delete()});
        return Future.value();
      });
    }
  }

  Future<MealPlanCollectionEntity> getMealPlanGroupByID(String id) async {
    var doc = await _firestore.collection(MEAL_PLAN_GROUPS).doc(id).get();

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(doc.data()!, doc.id));
  }

  Future<Map<String, String>> _getCreationUsersMap() async {
    Map<String, String> result = {};

    if (kIsWeb) {
      var handshakes = await sl
          .get<FirebaseWebLoginManager>()
          .getAllExistingWebHandshakes(userUid);

      for (var item in handshakes.docs) {
        var model = FirebaseHandshake.fromJson(item.data(), item.id);
        result.putIfAbsent(model.requestor, () => 'Web Session');
      }
    }

    if (this.userUid == this.ownerUserId) {
      result.putIfAbsent(userUid, () => 'owner');
    } else {
      result.putIfAbsent(ownerUserId!, () => 'owner');
      result.putIfAbsent(userUid, () => 'Web Session');
    }

    return result;
  }

  Future<MealPlanEntity?> getMealPlanByID(String id) async {
    var doc = await _firestore.collection(MEAL_PLANS).doc(id).get();
    if (!doc.exists) {
      return Future.value(null);
    }
    var parsedDoc = FirebaseMealPlanDocument.fromJson(doc.data()!, doc.id);
    return MealPlanEntityFirebase.of(parsedDoc);
  }

  Future<void> updateImageReference(String id, String value) async {
    var docRef = _firestore.collection(RECIPES).doc(id);
    var doc = await docRef.get();

    var firebaseRecipe = FirebaseRecipe.fromJson(doc.data()!, id: doc.id);
    firebaseRecipe.image = value;

    await docRef.update({'image': value});
  }

  Future<ShoppingListEntity> createOrUpdateShoppingList(
      ShoppingListEntity entity) async {
    assert(entity.groupID.isNotEmpty);
    if (entity.id == null || entity.id!.isEmpty) {
      assert(entity.items.isNotEmpty);
    }

    var json = FirebaseShoppingListDocument.from(entity).toJson();
    DocumentReference<Map<String, dynamic>> document;

    if (entity.id != null && entity.id!.isNotEmpty) {
      document = _firestore.collection(SHOPPING_LISTS).doc(entity.id);
      await document.set(json);
    } else {
      document = await _firestore.collection(SHOPPING_LISTS).add(json);
    }

    var model = await document.get();

    return ShoppingListEntityFirebase.of(
        FirebaseShoppingListDocument.fromJson(model.data()!, model.id));
  }

  Future<void> removeFromMealPlan(UserEntity user, String mealPlan) {
    return _removeMemberFromMealPlanGroup(mealPlan, user.id);
  }

  Future<void> removeFromRecipeGroup(UserEntity user, String group) {
    return _removeMemberFromRecipeGroup(group, user.id);
  }
}
