// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cookza/model/firebase/general/firebase_handshake.dart';
// import 'package:cookza/screens/web/web_landing_screen.dart';
// import 'package:cookza/services/abstract/platform_info.dart';
// import 'package:cookza/services/firebase_provider.dart';
// import 'package:cookza/services/flutter/navigator_service.dart';
// import 'package:cookza/services/flutter/service_locator.dart';
// import 'package:flutter/material.dart';

// typedef OnAcceptWebLogin = void Function(BuildContext context);

// class FirebaseWebLoginManager {
//   String? _webSessionHandshake;

//   final FirebaseFirestore _firestore = sl.get<FirebaseFirestore>();
//   final FirebaseProvider _firebaseProvider = sl.get<FirebaseProvider>();

//   Future<QuerySnapshot> _getAllExistingWebHandshakes(String userUid) async {
//     var handshakeSnapshots = await _firestore
//         .collection(HANDSHAKES)
//         .where('owner', isEqualTo: userUid)
//         .get();
//     return handshakeSnapshots;
//   }

//   /// called by the web app to create an initial requestor-handshake document
//   Future<String> initializeWebLogin(
//       OnAcceptWebLogin onLoginAccepted, BuildContext context) async {
//     if (_webSessionHandshake != null) {
//       return _webSessionHandshake!;
//     }

//     if (!_firebaseProvider.isLoggedIn()) {
//       await _firebaseProvider.signInAnonymously();
//     }

//     var platformInfo = sl.get<PlatformInfo>();

//     var newHandshakeEntry = FirebaseHandshake(
//         requestor: _firebaseProvider.userUid,
//         browser: platformInfo.browser,
//         operatingSystem: platformInfo.os,
//         owner: '');

//     // add entry
//     var document =
//         await _firestore.collection(HANDSHAKES).add(newHandshakeEntry.toJson());

//     _firestore.collection(HANDSHAKES).doc(document.id).snapshots().listen(
//       (event) async {
//         if (!event.exists) {
//           await _handleWebReceivedLogOff(context);
//           return;
//         }
//         _handleWebReceivedLogIn(context, event, onLoginAccepted);
//       },
//     );

//     _webSessionHandshake = document.id;
//     return _webSessionHandshake!;
//   }

//   ///  signals the web app that access has been granted
//   void enableWebLoginFor(String documentID) async {
//     var document =
//         await _firestore.collection(HANDSHAKES).doc(documentID).get();

//     var handshake = FirebaseHandshake.fromJson(document.data()!, document.id);

//     if (handshake.requestor.isEmpty) {
//       print('no webclient ID');
//       return;
//     }

//     handshake.owner = userUid;

//     var recipeGroupSnapshot = await _firestore
//         .collection(RECIPE_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     var mealPlanGroupSnapshot = await _firestore
//         .collection(MEAL_PLAN_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     var handshakeRef = _firestore.collection(HANDSHAKES).doc(documentID);

//     await _firestore.runTransaction<int>((transaction) {
//       int updates =
//           recipeGroupSnapshot.docs.length + mealPlanGroupSnapshot.docs.length;

//       // for each group we have access to, grant access to the given user
//       for (var item in recipeGroupSnapshot.docs) {
//         transaction.update(
//           item.reference,
//           {'users.${handshake.requestor}': 'Web Session'},
//         );
//       }

//       for (var item in mealPlanGroupSnapshot.docs) {
//         transaction.update(
//           item.reference,
//           {'users.${handshake.requestor}': 'Web Session'},
//         );
//       }

//       transaction.update(handshakeRef, handshake.toJson());
//       return Future.value(updates);
//     });
//   }

//   /// get all accepted web app sessions
//   Stream<List<FirebaseHandshake>> webAppSessions() {
//     var res = _firestore
//         .collection(HANDSHAKES)
//         .where('owner', isEqualTo: userUid)
//         .snapshots()
//         .map((e) => e.docs
//             .map((e) => FirebaseHandshake.fromJson(e.data(), e.id))
//             .toList());
//     return res;
//   }

//   /// log off from the given web client session
//   Future<void> logOffFromWebClient(String requestor) async {
//     // TODO: delete each doc where the owner is the requestor!
//     var docs = await _firestore
//         .collection(HANDSHAKES)
//         .where('requestor', isEqualTo: requestor)
//         .where('owner', isEqualTo: _ownerUserID)
//         .limit(1)
//         .get();

//     var recipeGroupSnapshot = await _firestore
//         .collection(RECIPE_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     var mealPlanGroupSnapshot = await _firestore
//         .collection(MEAL_PLAN_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     await _firestore.runTransaction<int>((transaction) {
//       int updates =
//           recipeGroupSnapshot.docs.length + mealPlanGroupSnapshot.docs.length;
//       // for each group we have access to, grant access to the given user
//       for (var item in recipeGroupSnapshot.docs) {
//         // setting the map value to null will remove the entry
//         transaction.update(
//           item.reference,
//           {'users.$requestor': FieldValue.delete()},
//         );
//       }

//       for (var item in mealPlanGroupSnapshot.docs) {
//         // setting the map value to null will remove the entry
//         transaction.update(
//           item.reference,
//           {'users.$requestor': FieldValue.delete()},
//         );
//       }

//       transaction.delete(docs.docs.first.reference);

//       return Future.value(updates);
//     });

//     var handshakes = await _firestore
//         .collection(HANDSHAKES)
//         .where('requestor', isEqualTo: requestor)
//         .where('owner', isEqualTo: userUid)
//         .limit(1)
//         .get();

//     handshakes.docs.forEach(
//       (element) {
//         element.reference.delete();
//       },
//     );
//   }

//   /// log off from all web client sessions
//   Future<int> logOffAllWebClient() async {
//     QuerySnapshot handshakeSnapshots = await _getAllExistingWebHandshakes();

//     var recipeGroupSnapshot = await _firestore
//         .collection(RECIPE_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     var mealPlanGroupSnapshot = await _firestore
//         .collection(MEAL_PLAN_GROUPS)
//         .where('users.$userUid', isGreaterThan: '')
//         .get();

//     return await _firestore.runTransaction<int>((transaction) {
//       int updates = handshakeSnapshots.docs.length +
//           recipeGroupSnapshot.docs.length +
//           mealPlanGroupSnapshot.docs.length;

//       for (var item in handshakeSnapshots.docs) {
//         var requestor = item.data()['requestor'];

//         for (var item in recipeGroupSnapshot.docs) {
//           // setting the map value to null will remove the entry
//           transaction.update(
//             item.reference,
//             {'users.$requestor': FieldValue.delete()},
//           );
//         }

//         for (var item in mealPlanGroupSnapshot.docs) {
//           // setting the map value to null will remove the entry
//           transaction.update(
//             item.reference,
//             {'users.$requestor': FieldValue.delete()},
//           );
//         }

//         // delete the handshake
//         transaction.delete(item.reference);
//       }
//       return Future.value(updates);
//     });
//   }

//   void _handleWebReceivedLogIn(
//       BuildContext context, DocumentSnapshot event, OnAcceptWebLogin callback) {
//     var target = FirebaseHandshake.fromJson(event.data()!, event.id);
//     // wait until somebody accepts the offer
//     if (target.owner.isNotEmpty) {
//       // update owners uid
//       _ownerUserID = target.owner;
//       // navigate to the home screen
//       callback.call(context);
//     }
//   }

//   Future<void> _handleWebReceivedLogOff(BuildContext context) async {
//     this._ownerUserID = null;
//     this._currentUser = null;
//     this._webSessionHandshake = null;
//     await this._auth.signOut();

//     await sl
//         .get<NavigatorService>()
//         .navigateToNewInitialRoute(WebLandingPage.id);
//   }
// }
