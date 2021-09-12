import 'package:cookza/screens/collections/qr_scanner.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
import 'package:cookza/screens/favorites/favorites_screen.dart';
import 'package:cookza/screens/groups/recipe_group.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/leftovers_screen.dart';
import 'package:cookza/screens/groups/meal_plan_group.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/screens/ocr_creation/ingredients_image_step.dart';
import 'package:cookza/screens/ocr_creation/instruction_image_step.dart';
import 'package:cookza/screens/ocr_creation/overview_image_step.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/screens/settings/about_screen.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/screens/settings/export_settings_screen.dart';
import 'package:cookza/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/screens/settings/saved_images_screen.dart';
import 'package:cookza/screens/settings/settings_screen.dart';
import 'package:cookza/screens/settings/shopping_list_settings_screen.dart';
import 'package:cookza/screens/settings/theme_settings_screen.dart';
import 'package:cookza/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookza/screens/web/web_landing_screen.dart';
import 'package:cookza/screens/web_login_app.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> kRoutes = {
  HomeScreen.id: (context) => const HomeScreen(),
  RecipeScreen.id: (context) => const RecipeScreen(),
  NewRecipeScreen.id: (context) => const NewRecipeScreen(),
  SettingsScreen.id: (context) => const SettingsScreen(),
  MealPlanScreen.id: (context) => const MealPlanScreen(),
  OnBoardingScreen.id: (context) => const OnBoardingScreen(),
  RecipeListScreen.id: (context) => const RecipeListScreen(),
  RecipeSelectionScreen.id: (context) => const RecipeSelectionScreen(),
  NewIngredientScreen.id: (context) => const NewIngredientScreen(),
  UoMVisibilityScreen.id: (context) => const UoMVisibilityScreen(),
  ThemeSettingsScreen.id: (context) => const ThemeSettingsScreen(),
  MealPlanSettingsScreen.id: (context) => const MealPlanSettingsScreen(),
  SavedImagesScreen.id: (context) => const SavedImagesScreen(),
  ExportSettingsScreen.id: (context) => const ExportSettingsScreen(),
  LeftoversScreen.id: (context) => const LeftoversScreen(),
  WebLoginOnAppScreen.id: (context) => const WebLoginOnAppScreen(),
  ShoppingListOverviewScreen.id: (context) =>
      const ShoppingListOverviewScreen(),
  ShoppingListDetailScreen.id: (context) => const ShoppingListDetailScreen(),
  RecipeGroupScreen.id: (context) => const RecipeGroupScreen(),
  ShareAccountScreen.id: (context) => ShareAccountScreen(),
  MealPlanGroupScreen.id: (context) => const MealPlanGroupScreen(),
  AboutScreen.id: (context) => const AboutScreen(),
  WebLandingPage.id: (context) => const WebLandingPage(),
  OCROverviewImageScreen.id: (context) => const OCROverviewImageScreen(),
  OCRIngredientsImageScreen.id: (context) => const OCRIngredientsImageScreen(),
  OCRInstructionsImageScreen.id: (context) =>
      const OCRInstructionsImageScreen(),
  ShoppingListSettingsScreen.id: (context) =>
      const ShoppingListSettingsScreen(),
  ErrorLogScreen.id: (context) => const ErrorLogScreen(),
  QrScannerScreen.id: (context) => const QrScannerScreen(),
  FavoriteRecipesScreen.id: (context) => const FavoriteRecipesScreen()
};
