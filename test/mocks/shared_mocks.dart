import 'package:cookza/services/api/chefkoch.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/image_parser.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ShoppingListItemsGenerator,
  StorageProvider,
  RecipeManager,
  ShoppingListManager,
  StackTrace,
  SimilarityService,
  FirebaseAuth,
  User,
  ChefkochAccessor
], customMocks: [
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
  MockSpec<MealPlanManager>(returnNullOnMissingStub: true),
  MockSpec<ImageManager>(returnNullOnMissingStub: true),
  MockSpec<FirebaseProvider>(returnNullOnMissingStub: true),
  MockSpec<ImageTextExtractor>(returnNullOnMissingStub: true),
  MockSpec<NavigatorService>(returnNullOnMissingStub: true)
])
class Dummy {
  // just a dummy class to generate mocks
}
