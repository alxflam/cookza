import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(() {
    // GetIt.I.registerSingleton<FirebaseAuth>(MockFirebaseAuth());
    // GetIt.I.registerSingleton<FirebaseFirestore>(MockFirestoreInstance());
  });

  // test(
  //   'Test initialization',
  //   () async {
  //     var cut = FirebaseProvider();
  //     await cut.init();

  //     expect(cut.userUid, isNotNull);
  //   },
  // );
}
