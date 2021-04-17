import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/shared_mocks.mocks.dart';

void resetFirestoreMock() {
  var mock = GetIt.I.get<FirebaseFirestore>();
  if (mock is MockFirestoreInstance) {
    mock.reset();
  }
}

Future<void> mockFirestore() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  var prefProvider = await SharedPreferencesProviderImpl().init();
  SharedPreferences.setMockInitialValues({});
  GetIt.I.registerSingleton<SharedPreferencesProvider>(prefProvider);

  var auth = MockFirebaseAuth();
  final instance = MockFirestoreInstance();

  GetIt.I.registerSingleton<FirebaseFirestore>(instance);

  GetIt.I.registerSingleton<FirebaseAuth>(auth);
  GetIt.I.registerSingleton<RecipeManager>(RecipeManagerFirebase());
  GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerFirebase());

  var firebase = FirebaseProvider();
  GetIt.I.registerSingleton<FirebaseProvider>(firebase);

  var user = MockUser();
  when(auth.currentUser).thenReturn(user);
  when(user.uid).thenReturn('1234');

  await firebase.init();
}
