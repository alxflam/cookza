import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookza/model/entities/firebase/instruction_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/firebase/meal_plan_entity.dart';
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
import 'package:cookza/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookza/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:cookza/screens/web/web_landing_screen.dart';
import 'package:cookza/services/abstract/platform_info.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnAcceptWebLogin = void Function(BuildContext context);

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const HANDSHAKES = 'handshakes';
  static const RECIPE_GROUPS = 'recipeGroups';
  static const INGREDIENTS = 'ingredients';
  static const INSTRUCTIONS = 'instructions';

  static const RECIPES = 'recipes';
  static const MEAL_PLAN_GROUPS = 'mealPlanGroups';
  static const MEAL_PLANS = 'mealPlans';

  static const SHOPPING_LISTS = 'shoppingLists';

  String _webSessionHandshake;

  User _currentUser;
  String _ownerUserID;

  Stream<List<MealPlanCollectionEntity>> get mealPlanGroups {
    return _mealPlanGroupsQuery().snapshots().map((e) => e.docs
        .where((e) => e.exists)
        .map((e) => MealPlanCollectionEntityFirebase.of(
            FirebaseMealPlanCollection.fromJson(e.data(), e.id)))
        .toList());
  }

  Future<List<ShoppingListEntity>> get shoppingListsAsList async {
    var groups = (await mealPlanGroupsAsList).map((e) => e.id).toList();
    var docs = await _shoppingListsQuery(groups).get();

    return docs.docs
        .map((e) => ShoppingListEntityFirebase.of(
            FirebaseShoppingListDocument.fromJson(e.data(), e.id)))
        .toList();
  }

  Future<List<QueryDocumentSnapshot>> getShoppingListsByMealPlan(
      String mealPlan) async {
    var docs = await _shoppingListsQuery([mealPlan]).get();

    return docs.docs;
  }

  Stream<List<ShoppingListEntity>> get shoppingListsAsStream {
    // TODO: cache groups until visiting meal plan screen
    var groups = [];

    return _shoppingListsQuery(groups).snapshots().map((e) => e.docs
        .map((e) => ShoppingListEntityFirebase.of(
            FirebaseShoppingListDocument.fromJson(e.data(), e.id)))
        .toList());
  }

  Query _mealPlanGroupsQuery() {
    return _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '');
  }

  Query _shoppingListsQuery(List<String> groups) {
    return _firestore
        .collection(SHOPPING_LISTS)
        .where('groupID', whereIn: groups);
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
            creationTimestamp: Timestamp.now(),
            users: await _getCreationUsersMap(),
          ).toJson(),
        );
    var model = await document.get();
    print('created meal plan collection ${document.id}');

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(model.data(), model.id));
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
    }

    _currentUser = _auth.currentUser;
    if (_currentUser == null) {
      await _signInAnonymously();
    }
    _ownerUserID = _currentUser.uid;

    print('logged in anonymously using token ${_currentUser.uid}');

    /// notify dependent services that firebase is ready to use now
    /// TODO refactor: use GetIt dependencies instead of manually triggering the init...
    Future.microtask(() {
      // TODO: await finish of shared preferences? or how to sync?
      // maybe make firebase provider dependent of shared preferences
      /// initialize recipe manager
      sl.get<RecipeManager>().init();

      /// initialize meal plan manager
      return sl.get<MealPlanManager>().init();
    });

    return this;
  }

  Future _signInAnonymously() async {
    var result = await _auth.signInAnonymously();
    _currentUser = result.user;
  }

  /// returns the UID assigned to the currently logged in user
  String get userUid {
    return _currentUser?.uid;
  }

  /// called by the web app to create an initial requestor-handshake document
  Future<String> initializeWebLogin(
      OnAcceptWebLogin onLoginAccepted, BuildContext context) async {
    if (_webSessionHandshake != null) {
      return _webSessionHandshake;
    }

    if (this._currentUser == null) {
      await _signInAnonymously();
    }

    var platformInfo = sl.get<PlatformInfo>();

    var newHandshakeEntry = FirebaseHandshake(
        requestor: userUid,
        browser: platformInfo.browser,
        operatingSystem: platformInfo.os);

    // add entry
    var document =
        await _firestore.collection(HANDSHAKES).add(newHandshakeEntry.toJson());

    _firestore.collection(HANDSHAKES).doc(document.id).snapshots().listen(
      (event) {
        if (!event.exists) {
          return _handleWebReceivedLogOff(context);
        }
        _handleWebReceivedLogIn(context, event, onLoginAccepted);
      },
    );

    _webSessionHandshake = document.id;
    return _webSessionHandshake;
  }

  ///  signals the web app that access has been granted
  void enableWebLoginFor(String documentID) async {
    var document =
        await _firestore.collection(HANDSHAKES).doc(documentID).get();

    var handshake = FirebaseHandshake.fromJson(document.data(), document.id);

    if (handshake.requestor == null || handshake.requestor.isEmpty) {
      print('no webclient ID');
      return;
    }

    handshake.owner = userUid;

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    var handshakeRef = _firestore.collection(HANDSHAKES).doc(documentID);

    await _firestore.runTransaction<int>((transaction) {
      int updates =
          recipeGroupSnapshot.docs.length + mealPlanGroupSnapshot.docs.length;

      // for each group we have access to, grant access to the given user
      for (var item in recipeGroupSnapshot.docs) {
        transaction.update(
          item.reference,
          {'users.${handshake.requestor}': 'Web Session'},
        );
      }

      for (var item in mealPlanGroupSnapshot.docs) {
        transaction.update(
          item.reference,
          {'users.${handshake.requestor}': 'Web Session'},
        );
      }

      transaction.update(handshakeRef, handshake.toJson());
      return Future.value(updates);
    });
  }

  /// get all accepted web app sessions
  Stream<List<FirebaseHandshake>> webAppSessions() {
    var res = _firestore
        .collection(HANDSHAKES)
        .where('owner', isEqualTo: userUid)
        .snapshots()
        .map((e) => e.docs
            .map((e) => FirebaseHandshake.fromJson(e.data(), e.id))
            .toList());
    return res;
  }

  /// log off from the given web client session
  Future<void> logOffFromWebClient(String requestor) async {
    // TODO: delete each doc where the owner is the requestor!
    var docs = await _firestore
        .collection(HANDSHAKES)
        .where('requestor', isEqualTo: requestor)
        .where('owner', isEqualTo: _ownerUserID)
        .limit(1)
        .get();

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    await _firestore.runTransaction<int>((transaction) {
      int updates =
          recipeGroupSnapshot.docs.length + mealPlanGroupSnapshot.docs.length;
      // for each group we have access to, grant access to the given user
      for (var item in recipeGroupSnapshot.docs) {
        // setting the map value to null will remove the entry
        transaction.update(
          item.reference,
          {'users.$requestor': FieldValue.delete()},
        );
      }

      for (var item in mealPlanGroupSnapshot.docs) {
        // setting the map value to null will remove the entry
        transaction.update(
          item.reference,
          {'users.$requestor': FieldValue.delete()},
        );
      }

      transaction.delete(docs.docs.first.reference);

      return Future.value(updates);
    });

    var handshakes = await _firestore
        .collection(HANDSHAKES)
        .where('requestor', isEqualTo: requestor)
        .where('owner', isEqualTo: userUid)
        .limit(1)
        .get();

    handshakes.docs.forEach(
      (element) {
        element.reference.delete();
      },
    );
  }

  /// log off from all web client sessions
  Future<void> logOffAllWebClient() async {
    QuerySnapshot handshakeSnapshots = await _getAllExistingWebHandshakes();

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .get();

    return await _firestore.runTransaction<int>((transaction) {
      int updates = handshakeSnapshots.docs.length +
          recipeGroupSnapshot.docs.length +
          mealPlanGroupSnapshot.docs.length;

      for (var item in handshakeSnapshots.docs) {
        var requestor = item.data()['requestor'];

        for (var item in recipeGroupSnapshot.docs) {
          // setting the map value to null will remove the entry
          transaction.update(
            item.reference,
            {'users.$requestor': FieldValue.delete()},
          );
        }

        for (var item in mealPlanGroupSnapshot.docs) {
          // setting the map value to null will remove the entry
          transaction.update(
            item.reference,
            {'users.$requestor': FieldValue.delete()},
          );
        }

        // delete the handshake
        transaction.delete(item.reference);
      }
      return Future.value(updates);
    });
  }

  Future<QuerySnapshot> _getAllExistingWebHandshakes() async {
    var handshakeSnapshots = await _firestore
        .collection(HANDSHAKES)
        .where('owner', isEqualTo: userUid)
        .get();
    return handshakeSnapshots;
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
    print('created recipe collection ${document.id}');

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(model.data(), model.id));
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
    var ingredients = await FirebaseIngredient.from(recipe);
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
        FirebaseIngredientDocument.from(ingredients, recipeDocRef.id);

    batch.set(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.id);

    batch.set(instructionsDocRef, instructionsDoc.toJson());

    await batch.commit();

    return recipeDocRef.id;
  }

  Future<String> _updateRecipe(RecipeEntity recipe) async {
    var baseRecipe = FirebaseRecipe.from(recipe);
    var ingredients = await FirebaseIngredient.from(recipe);
    var instructions = await FirebaseInstruction.from(recipe);

    var recipeDocRef = _firestore.collection(RECIPES).doc(recipe.id);

    var batch = _firestore.batch();
    batch.set(recipeDocRef, baseRecipe.toJson());

    var ingredientsDoc =
        FirebaseIngredientDocument.from(ingredients, recipeDocRef.id);

    var ingredientsDocRef =
        _firestore.collection(INGREDIENTS).doc(recipeDocRef.id);
    batch.set(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.id);

    var instructionsDocRef =
        _firestore.collection(INSTRUCTIONS).doc(recipeDocRef.id);
    batch.set(instructionsDocRef, instructionsDoc.toJson());

    await batch.commit();

    print('updated recipe ${recipe.id}');

    return recipe.id;
  }

  Future<void> deleteRecipe(RecipeEntity recipe) async {
    await _firestore.collection(RECIPES).doc(recipe.id).delete();
    print('deleted recipe ${recipe.id}');
  }

  Future<RecipeCollectionEntity> recipeCollectionByID(String id) async {
    var doc = await _firestore.collection(RECIPE_GROUPS).doc(id).get();

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(doc.data(), doc.id));
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
      await sl.get<ImageManager>().deleteRecipeImage(entity);
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

  Future<void> deleteMealPlanCollection(String id) async {
    var reference = _firestore.collection(MEAL_PLAN_GROUPS).doc(id);

    var snapshot = await _firestore
        .collection(MEAL_PLANS)
        .where('groupID', isEqualTo: id)
        .limit(1)
        .get();

    var shoppingLists = await getShoppingListsByMealPlan(id);

    await _firestore.runTransaction((transaction) {
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

  Future<List<IngredientNoteEntityFirebase>> recipeIngredients(
      String recipeGroup, String recipeID) async {
    var doc = await _firestore.collection(INGREDIENTS).doc(recipeID).get();

    var docData = FirebaseIngredientDocument.fromJson(doc.data(), doc.id);

    return docData.ingredients
        .map((e) => IngredientNoteEntityFirebase.of(e))
        .toList();
  }

  Future<List<RecipeEntity>> getAllRecipes() async {
    var collections = await recipeCollectionsAsList();
    if (collections.isEmpty) {
      return Future.value([]);
    }

    var docs = await _firestore
        .collection(RECIPES)
        .where('recipeGroupID', whereIn: collections.map((e) => e.id).toList())
        .orderBy('name')
        .get();

    print('all documents retrieved ${docs.docs.length} results');

    return docs.docs
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data(), id: e.id)))
        .toList();
  }

  Future<List<RecipeEntity>> getRecipeById(List<String> ids) async {
    var docs = await _firestore
        .collection(RECIPES)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return docs.docs
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data(), id: e.id)))
        .toList();
  }

  Future<List<InstructionEntityFirebase>> recipeInstructions(
      String recipeGroup, String recipeID) async {
    var doc = await _firestore.collection(INSTRUCTIONS).doc(recipeID).get();

    var data = FirebaseInstructionDocument.fromJson(doc.data(), doc.id);

    print('instructions received: ${data.instructions.length}');

    var result =
        data.instructions.map((e) => InstructionEntityFirebase.of(e)).toList();
    result.sort((a, b) {
      if (a.step == null || b.step == null) {
        return 0;
      }
      return a.step.compareTo(b.step ?? 0);
    });
    return result;
  }

  Future<void> updateRating(RecipeEntity recipe, int rating) {
    var recipeDocRef = _firestore.collection(RECIPES).doc(recipe.id);

    return recipeDocRef.set({'rating': rating}, SetOptions(merge: true));
  }

  Future<MealPlanEntity> mealPlan(String groupID) async {
    var snapshot = await _firestore
        .collection(MEAL_PLANS)
        .where('groupID', isEqualTo: groupID)
        .limit(1)
        .get();

    var parsedDoc;

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
    assert(entity.groupID != null && entity.groupID.isNotEmpty);
    DocumentReference docRef;
    if (entity.id != null && entity.id.isNotEmpty) {
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
      var target = MutableRecipe.of(recipe);
      target.id = null;
      target.recipeCollectionId = groupId;
      var id = await _createRecipe(target);
      var mutableRecipe = MutableRecipe.of(recipe);
      mutableRecipe.id = id;
      ids.add(mutableRecipe);
    }
    return ids;
  }

  Future<void> leaveMealPlanGroup(String id) async {
    return await _removeMemberFromMealPlanGroup(id, this.userUid);
  }

  Future<void> _removeMemberFromMealPlanGroup(
      String mealPlanID, String userID) async {
    var docRef = _firestore.collection(MEAL_PLAN_GROUPS).doc(mealPlanID);

    var doc = await docRef.get(GetOptions(source: Source.server));
    var mealPlan = FirebaseMealPlanCollection.fromJson(doc.data(), doc.id);
    var deleteMealPlan =
        mealPlan.users.entries.where((a) => a.key != userID).isEmpty;

    if (deleteMealPlan) {
      return deleteMealPlanCollection(mealPlanID);
    } else {
      return _firestore.runTransaction<int>((transaction) {
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

    var doc = await docRef.get(GetOptions(source: Source.server));
    var recipeGroup = FirebaseRecipeCollection.fromJson(doc.data(), doc.id);
    var deleteGroup =
        recipeGroup.users.entries.where((a) => a.key != userID).isEmpty;

    if (deleteGroup) {
      return deleteRecipeCollection(groupID);
    } else {
      return _firestore.runTransaction<int>((transaction) {
        transaction.update(docRef, {'users.$userID': FieldValue.delete()});
        return Future.value(1);
      });
    }
  }

  Future<MealPlanCollectionEntity> getMealPlanGroupByID(String id) async {
    var doc = await _firestore.collection(MEAL_PLAN_GROUPS).doc(id).get();

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(doc.data(), doc.id));
  }

  void _handleWebReceivedLogIn(
      BuildContext context, DocumentSnapshot event, OnAcceptWebLogin callback) {
    var target = FirebaseHandshake.fromJson(event.data(), event.id);
    // wait until somebody accepts the offer
    if (target.owner != null) {
      // update owners uid
      _ownerUserID = target.owner;
      // navigate to the home screen
      callback.call(context);
    }
  }

  Future<void> _handleWebReceivedLogOff(BuildContext context) async {
    this._ownerUserID = null;
    this._currentUser = null;
    this._webSessionHandshake = null;
    await this._auth.signOut();

    await sl
        .get<NavigatorService>()
        .navigateToNewInitialRoute(WebLandingPage.id);
  }

  Future<Map<String, String>> _getCreationUsersMap() async {
    Map<String, String> result = {};

    if (kIsWeb) {
      var handshakes = await _getAllExistingWebHandshakes();

      for (var item in handshakes.docs) {
        var model = FirebaseHandshake.fromJson(item.data(), item.id);
        result.putIfAbsent(model.requestor, () => 'Web Session');
      }
    }

    if (this.userUid == this._ownerUserID) {
      result.putIfAbsent(userUid, () => 'owner');
    } else {
      result.putIfAbsent(_ownerUserID, () => 'owner');
      result.putIfAbsent(userUid, () => 'Web Session');
    }

    return result;
  }

  Future<MealPlanEntity> getMealPlanByID(String id) async {
    // TODO: change query to where if ever doc id of meal plan is different from meal plan group
    var doc = await _firestore.collection(MEAL_PLANS).doc(id).get();
    var parsedDoc = FirebaseMealPlanDocument.fromJson(doc.data(), doc.id);
    return MealPlanEntityFirebase.of(parsedDoc);
  }

  Future<void> updateImageReference(String id, String value) async {
    var docRef = _firestore.collection(RECIPES).doc(id);
    var doc = await docRef.get();

    var firebaseRecipe = FirebaseRecipe.fromJson(doc.data(), id: doc.id);
    firebaseRecipe.image = value;

    await docRef.update({'image': value});
  }

  Future<ShoppingListEntity> createOrUpdateShoppingList(
      ShoppingListEntity entity) async {
    assert(entity.groupID != null && entity.groupID.isNotEmpty);
    assert(entity.dateFrom != null);
    assert(entity.dateUntil != null);
    assert(entity.items != null);
    if (entity.id == null || entity.id.isEmpty) {
      assert(entity.items.isNotEmpty);
    }

    var json = FirebaseShoppingListDocument.from(entity).toJson();
    DocumentReference document;

    if (entity.id != null && entity.id.isNotEmpty) {
      document = _firestore.collection(SHOPPING_LISTS).doc(entity.id);
      await document.set(json);
    } else {
      document = await _firestore.collection(SHOPPING_LISTS).add(json);
    }

    var model = await document.get();

    return ShoppingListEntityFirebase.of(
        FirebaseShoppingListDocument.fromJson(model.data(), model.id));
  }

  Future<void> removeFromMealPlan(UserEntity user, String mealPlan) {
    return _removeMemberFromMealPlanGroup(mealPlan, user.id);
  }

  Future<void> removeFromRecipeGroup(UserEntity user, String group) {
    return _removeMemberFromRecipeGroup(group, user.id);
  }
}
