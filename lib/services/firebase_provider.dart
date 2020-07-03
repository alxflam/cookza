import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookly/model/entities/firebase/instruction_entity.dart';
import 'package:cookly/model/entities/firebase/meal_plan_collection_entity.dart';
import 'package:cookly/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookly/model/entities/firebase/recipe_collection_entity.dart';
import 'package:cookly/model/entities/firebase/recipe_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/model/firebase/collections/firebase_meal_plan_collection.dart';
import 'package:cookly/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookly/model/firebase/general/firebase_handshake.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/firebase/recipe/firebase_instruction.dart';
import 'package:cookly/model/firebase/recipe/firebase_recipe.dart';
import 'package:cookly/screens/web/web_landing_screen.dart';
import 'package:cookly/services/abstract/platform_info.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnAcceptWebLogin = void Function(BuildContext context);

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  static const HANDSHAKES = 'handshakes';
  static const RECIPE_GROUPS = 'recipeGroups';
  static const INGREDIENTS = 'ingredients';
  static const INSTRUCTIONS = 'instructions';

  static const RECIPES = 'recipes';
  static const MEAL_PLAN_GROUPS = 'mealPlanGroups';
  static const MEAL_PLANS = 'mealPlans';

  String _webSessionHandshake;

  FirebaseUser _currentUser;
  String _ownerUserID;

  String _currentRecipeGroup;

  FirebaseProvider();

  String get currentRecipeGroup => _currentRecipeGroup;

  Stream<List<MealPlanCollectionEntity>> get mealPlanGroups {
    return _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .snapshots()
        .map((e) => e.documents
            .map((e) => MealPlanCollectionEntityFirebase.of(
                FirebaseMealPlanCollection.fromJson(e.data, e.documentID)))
            .toList());
  }

  /// create a new recipe collection
  Future<MealPlanCollectionEntityFirebase> createMealPlanGroup(
      String name) async {
    var document = await _firestore.collection(MEAL_PLAN_GROUPS).add(
          FirebaseMealPlanCollection(
            name: name,
            creationTimestamp: Timestamp.now(),
            users: {this.userUid: 'owner'},
          ).toJson(),
        );
    var model = await document.get();
    print('created meal plan collection ${document.documentID}');

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(model.data, model.documentID));
  }

  Future<void> renameMealPlanCollection(
      String name, MealPlanCollectionEntity entity) async {
    return _firestore
        .collection(MEAL_PLAN_GROUPS)
        .document(entity.id)
        .setData({'name': name}, merge: true);
  }

  /// retrieve all recipe collections the user can access
  Future<List<MealPlanCollectionEntity>> mealPlanCollectionsAsList() async {
    var docs = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    return docs.documents
        .map((e) => MealPlanCollectionEntityFirebase.of(
            FirebaseMealPlanCollection.fromJson(e.data, e.documentID)))
        .toList();
  }

  /// initialize firebase connection by ensuring the user is logged in
  Future<FirebaseProvider> init() async {
    var user = await _auth.currentUser();
    _currentUser = user;
    if (user == null) {
      await _signInAnonymously();
    }
    _ownerUserID = _currentUser.uid;

    print('logged in anonymously using token ${_currentUser.uid}');

    var coll = await this.recipeCollectionsAsList();
    print('coll is $coll');
    print('collection size is: ${coll.length}');
    if (coll.isEmpty && !kIsWeb) {
      var collection = await this.createRecipeCollection('default');
      this._currentRecipeGroup = collection.id;
    } else if (coll.isNotEmpty) {
      this._currentRecipeGroup = coll.first.id;
    }

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

    _firestore
        .collection(HANDSHAKES)
        .document(document.documentID)
        .snapshots()
        .listen(
      (event) {
        if (!event.exists) {
          return _handleWebReceivedLogOff(context);
        }
        _handleWebReceivedLogIn(context, event, onLoginAccepted);
      },
    );

    _webSessionHandshake = document.documentID;
    return _webSessionHandshake;
  }

  ///  signals the web app that access has been granted
  void enableWebLoginFor(String documentID) async {
    var document =
        await _firestore.collection(HANDSHAKES).document(documentID).get();

    var handshake =
        FirebaseHandshake.fromJson(document.data, document.documentID);

    if (handshake.requestor == null || handshake.requestor.isEmpty) {
      print('no webclient ID');
      return;
    }

    handshake.owner = userUid;

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    var handshakeRef = _firestore.collection(HANDSHAKES).document(documentID);

    await _firestore.runTransaction((transaction) {
      // for each group we have access to, grant access to the given user
      for (var item in recipeGroupSnapshot.documents) {
        transaction.update(
          item.reference,
          {'users.${handshake.requestor}': 'Web Session'},
        );
      }

      for (var item in mealPlanGroupSnapshot.documents) {
        transaction.update(
          item.reference,
          {'users.${handshake.requestor}': 'Web Session'},
        );
      }

      transaction.update(handshakeRef, handshake.toJson());
    });
  }

  /// get all accepted web app sessions
  Stream<List<FirebaseHandshake>> webAppSessions() {
    var res = _firestore
        .collection(HANDSHAKES)
        .where('owner', isEqualTo: userUid)
        .snapshots()
        .map((e) => e.documents
            .map((e) => FirebaseHandshake.fromJson(e.data, e.documentID))
            .toList());
    return res;
  }

  /// log off from the given web client session
  void logOffFromWebClient(String requestor) async {
    // TODO: delete each doc where the owner is the requestor!

    var docs = await _firestore
        .collection(HANDSHAKES)
        .where('requestor', isEqualTo: requestor)
        .where('owner', isEqualTo: userUid)
        .limit(1)
        .getDocuments();

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    await _firestore.runTransaction((transaction) {
      // for each group we have access to, grant access to the given user
      for (var item in recipeGroupSnapshot.documents) {
        // setting the map value to null will remove the entry
        transaction.update(
          item.reference,
          {'users.$requestor': null},
        );
      }

      for (var item in mealPlanGroupSnapshot.documents) {
        // setting the map value to null will remove the entry
        transaction.update(
          item.reference,
          {'users.$requestor': null},
        );
      }

      transaction.delete(docs.documents.first.reference);
    });

    _firestore
        .collection(HANDSHAKES)
        .where('requestor', isEqualTo: requestor)
        .where('owner', isEqualTo: userUid)
        .limit(1)
        .getDocuments()
        .then(
          (value) => value.documents.forEach(
            (element) {
              element.reference.delete();
            },
          ),
        );
  }

  /// log off from all web client sessions
  Future<void> logOffAllWebClient() async {
    var handshakeSnapshots = await _firestore
        .collection(HANDSHAKES)
        .where('owner', isEqualTo: userUid)
        .getDocuments();

    var recipeGroupSnapshot = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    var mealPlanGroupSnapshot = await _firestore
        .collection(MEAL_PLAN_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    return await _firestore.runTransaction((transaction) {
      for (var item in handshakeSnapshots.documents) {
        var requestor = item.data['requestor'];

        for (var item in recipeGroupSnapshot.documents) {
          // setting the map value to null will remove the entry
          transaction.update(
            item.reference,
            {'users.$requestor': null},
          );
        }

        for (var item in mealPlanGroupSnapshot.documents) {
          // setting the map value to null will remove the entry
          transaction.update(
            item.reference,
            {'users.$requestor': null},
          );
        }

        // delete the handshake
        transaction.delete(item.reference);
      }
    });
  }

  /// create a new recipe collection
  Future<RecipeCollectionEntity> createRecipeCollection(String name) async {
    var document = await _firestore.collection(RECIPE_GROUPS).add(
          FirebaseRecipeCollection(
            name: name,
            creationTimestamp: Timestamp.now(),
            users: {userUid: 'owner'},
          ).toJson(),
        );
    var model = await document.get();
    print('created recipe collection ${document.documentID}');

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(model.data, model.documentID));
  }

  Future<void> renameRecipeCollection(
      String name, RecipeCollectionEntity entity) async {
    return _firestore
        .collection(RECIPE_GROUPS)
        .document(entity.id)
        .setData({'name': name}, merge: true);
  }

  /// retrieve all recipe collections the user can access
  Future<List<RecipeCollectionEntity>> recipeCollectionsAsList() async {
    var docs = await _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .getDocuments();

    return docs.documents
        .map((e) => RecipeCollectionEntityFirebase.of(
            FirebaseRecipeCollection.fromJson(e.data, e.documentID)))
        .toList();
  }

  Stream<List<RecipeCollectionEntity>> recipeCollectionsAsStream() {
    return _firestore
        .collection(RECIPE_GROUPS)
        .where('users.$userUid', isGreaterThan: '')
        .snapshots()
        .map((e) => e.documents
            .map((e) => RecipeCollectionEntityFirebase.of(
                FirebaseRecipeCollection.fromJson(e.data, e.documentID)))
            .toList());
  }

  /// todo: option to get all or only from a specific recipe group
  Stream<List<RecipeEntity>> recipes() {
    return _firestore
        .collection(RECIPES)
        .where('recipeGroupID', isEqualTo: this._currentRecipeGroup)
        .orderBy('name')
        .snapshots()
        .map((e) => e.documents
            .map((e) => RecipeEntityFirebase.of(
                FirebaseRecipe.fromJson(e.data, id: e.documentID)))
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
    var recipeDocRef = _firestore.collection(RECIPES).document();

    var ingredientsDocRef =
        _firestore.collection(INGREDIENTS).document(recipeDocRef.documentID);

    var instructionsDocRef =
        _firestore.collection(INSTRUCTIONS).document(recipeDocRef.documentID);

    baseRecipe.documentID = recipeDocRef.documentID;
    baseRecipe.ingredientsID = ingredientsDocRef.documentID;
    baseRecipe.instructionsID = instructionsDocRef.documentID;

    var batch = _firestore.batch();
    batch.setData(recipeDocRef, baseRecipe.toJson());

    var ingredientsDoc =
        FirebaseIngredientDocument.from(ingredients, recipeDocRef.documentID);

    batch.setData(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.documentID);

    batch.setData(instructionsDocRef, instructionsDoc.toJson());

    batch.commit();

    return recipeDocRef.documentID;
  }

  Future<String> _updateRecipe(RecipeEntity recipe) async {
    var baseRecipe = FirebaseRecipe.from(recipe);
    var ingredients = await FirebaseIngredient.from(recipe);
    var instructions = await FirebaseInstruction.from(recipe);

    var recipeDocRef = _firestore.collection(RECIPES).document(recipe.id);

    var batch = _firestore.batch();
    batch.setData(recipeDocRef, baseRecipe.toJson());

    var ingredientsDoc =
        FirebaseIngredientDocument.from(ingredients, recipeDocRef.documentID);

    var ingredientsDocRef =
        _firestore.collection(INGREDIENTS).document(recipeDocRef.documentID);
    batch.setData(ingredientsDocRef, ingredientsDoc.toJson());

    var instructionsDoc =
        FirebaseInstructionDocument.from(instructions, recipeDocRef.documentID);

    var instructionsDocRef =
        _firestore.collection(INSTRUCTIONS).document(recipeDocRef.documentID);
    batch.setData(instructionsDocRef, instructionsDoc.toJson());

    batch.commit();

    print('updated recipe ${recipe.id}');

    return recipe.id;
  }

  Future<void> deleteRecipe(RecipeEntity recipe) async {
    await _firestore.collection(RECIPES).document(recipe.id).delete();
    print('deleted recipe ${recipe.id}');
  }

  setCurrentRecipeGroup(String documentID) {
    this._currentRecipeGroup = documentID;
  }

  Future<RecipeCollectionEntity> recipeCollectionByID(String id) async {
    var doc = await _firestore.collection(RECIPE_GROUPS).document(id).get();

    return RecipeCollectionEntityFirebase.of(
        FirebaseRecipeCollection.fromJson(doc.data, doc.documentID));
  }

  Future<void> deleteRecipeCollection(String id) async {
    // TODO: if collection has more than the current user, we should not allow deletion

    var collection = _firestore.collection(RECIPE_GROUPS).document(id);

    await _firestore.runTransaction((transaction) {
      transaction.delete(collection);

      // TODO also delete all recipes and other associated data
    });
  }

  Future<void> deleteMealPlanCollection(String id) async {
    // TODO: if collection has more than the current user, we should not allow deletion

    var collection = _firestore.collection(MEAL_PLAN_GROUPS).document(id);

    await _firestore.runTransaction((transaction) {
      transaction.delete(collection);

      // TODO also delete all meal plans and other associated data
    });
  }

  Future<void> addUserToCollection(
      RecipeCollectionEntity model, String newUserID, String name) async {
    var docRef = _firestore.collection(RECIPE_GROUPS).document(model.id);

    return await docRef.updateData({'users.$newUserID': name});
  }

  Future<void> addUserToMealPlanCollection(
      MealPlanCollectionEntity model, String newUserID, String name) async {
    var docRef = _firestore.collection(MEAL_PLAN_GROUPS).document(model.id);

    return await docRef.updateData({'users.$newUserID': name});
  }

  String getNextRecipeDocumentId(String recipeGroup) {
    var recipeDocRef = _firestore.collection(RECIPES).document();

    return recipeDocRef.documentID;
  }

  Future<List<IngredientNoteEntityFirebase>> recipeIngredients(
      String recipeGroup, String recipeID) async {
    var doc = await _firestore.collection(INGREDIENTS).document(recipeID).get();

    var docData = FirebaseIngredientDocument.fromJson(doc.data, doc.documentID);

    return docData.ingredients
        .map((e) => IngredientNoteEntityFirebase.of(e))
        .toList();
  }

  Future<List<RecipeEntity>> getAllRecipes() async {
    var collections = await recipeCollectionsAsList();

    var docs = await _firestore
        .collection(RECIPES)
        .where('recipeGroupID', whereIn: collections.map((e) => e.id).toList())
        .getDocuments();

    print('all documents retrieved ${docs.documents.length} results');

    return docs.documents
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data, id: e.documentID)))
        .toList();
  }

  Future<List<RecipeEntity>> getRecipeById(List<String> ids) async {
    var docs = await _firestore
        .collection(RECIPES)
        .where(FieldPath.documentId, whereIn: ids)
        .getDocuments();

    return docs.documents
        .map((e) => RecipeEntityFirebase.of(
            FirebaseRecipe.fromJson(e.data, id: e.documentID)))
        .toList();
  }

  Future<List<InstructionEntityFirebase>> recipeInstructions(
      String recipeGroup, String recipeID) async {
    var doc =
        await _firestore.collection(INSTRUCTIONS).document(recipeID).get();

    var data = FirebaseInstructionDocument.fromJson(doc.data, doc.documentID);

    print('instructions received: ${data.instructions.length}');

    var result =
        data.instructions.map((e) => InstructionEntityFirebase.of(e)).toList();
    result.sort((a, b) {
      if (a.step == null || b.step == null) {
        return 0;
      }
      return a.step.compareTo(b.step == null ? 0 : b.step);
    });
    return result;
  }

  Future<void> updateRating(RecipeEntity recipe, int rating) {
    var recipeDocRef = _firestore.collection(RECIPES).document(recipe.id);

    return recipeDocRef.setData({'rating': rating}, merge: true);
  }

  Future<MealPlanEntity> mealPlan(String groupID) async {
    var snapshot = await _firestore
        .collection(MEAL_PLANS)
        .where('groupID', isEqualTo: groupID)
        .limit(1)
        .getDocuments();

    var parsedDoc;

    if (snapshot.documents.isEmpty) {
      parsedDoc = FirebaseMealPlanDocument.empty(this.userUid, groupID);
    } else {
      var document = snapshot.documents.first;
      parsedDoc =
          FirebaseMealPlanDocument.fromJson(document.data, document.documentID);
    }

    var model = MealPlanEntityFirebase.of(parsedDoc);
    return model;
  }

  Future<String> saveMealPlan(MealPlanEntity entity) async {
    DocumentReference docRef;
    // TODO: somehow the ID is always null even if saved...return the documentID!!!
    if (entity.id != null && entity.id.isNotEmpty) {
      docRef = _firestore.collection(MEAL_PLANS).document(entity.id);
    } else {
      // creation with same id as the corresponding group
      docRef = _firestore.collection(MEAL_PLANS).document(entity.groupID);
    }

    var data = FirebaseMealPlanDocument.from(entity);

    await docRef.setData(data.toJson());

    return docRef.documentID;
  }

  Future<void> importRecipes(List<RecipeEntity> recipes) async {
    for (var recipe in recipes) {
      var target = MutableRecipe.of(recipe);
      target.id = null;
      target.recipeCollectionId = this.currentRecipeGroup;
      await _createRecipe(target);
    }
  }

  Future<void> leaveMealPlanGroup(String id) async {
    var docRef = _firestore.collection(MEAL_PLAN_GROUPS).document(id);

    return _firestore.runTransaction((transaction) {
      transaction.update(docRef, {'users.$userUid': null});
    });
  }

  Future<void> leaveRecipeGroup(String id) async {
    var docRef = _firestore.collection(RECIPE_GROUPS).document(id);

    return _firestore.runTransaction((transaction) {
      transaction.update(docRef, {'users.$userUid': null});
    });
  }

  Future<MealPlanCollectionEntity> getMealPlanGroupByID(String id) async {
    var doc = await _firestore.collection(MEAL_PLAN_GROUPS).document(id).get();

    return MealPlanCollectionEntityFirebase.of(
        FirebaseMealPlanCollection.fromJson(doc.data, doc.documentID));
  }

  void _handleWebReceivedLogIn(
      BuildContext context, DocumentSnapshot event, OnAcceptWebLogin callback) {
    var target = FirebaseHandshake.fromJson(event.data, event.documentID);
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

    sl.get<NavigatorService>().navigateTo(WebLandingPage.id);
  }
}
