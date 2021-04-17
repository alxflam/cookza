import 'package:cookza/screens/collections/live_camera_scanner_screen.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
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
import 'package:cookza/screens/settings/changelog_screen.dart';
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
import 'package:cookza/screens/web/web_login.dart';
import 'package:cookza/screens/web_login_app.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> kRoutes = {
  HomeScreen.id: (context) => HomeScreen(),
  // WebLoginScreen.id: (context) => WebLoginScreen(),
  RecipeScreen.id: (context) => RecipeScreen(),
  NewRecipeScreen.id: (context) => NewRecipeScreen(),
  SettingsScreen.id: (context) => SettingsScreen(),
  MealPlanScreen.id: (context) => MealPlanScreen(),
  OnBoardingScreen.id: (context) => OnBoardingScreen(),
  RecipeListScreen.id: (context) => RecipeListScreen(),
  RecipeSelectionScreen.id: (context) => RecipeSelectionScreen(),
  NewIngredientScreen.id: (context) => NewIngredientScreen(),
  UoMVisibilityScreen.id: (context) => UoMVisibilityScreen(),
  ThemeSettingsScreen.id: (context) => ThemeSettingsScreen(),
  MealPlanSettingsScreen.id: (context) => MealPlanSettingsScreen(),
  SavedImagesScreen.id: (context) => SavedImagesScreen(),
  ExportSettingsScreen.id: (context) => ExportSettingsScreen(),
  LeftoversScreen.id: (context) => LeftoversScreen(),
  // WebLoginOnAppScreen.id: (context) => WebLoginOnAppScreen(),
  ShoppingListOverviewScreen.id: (context) => ShoppingListOverviewScreen(),
  ShoppingListDetailScreen.id: (context) => ShoppingListDetailScreen(),
  RecipeGroupScreen.id: (context) => RecipeGroupScreen(),
  ShareAccountScreen.id: (context) => ShareAccountScreen(),
  MealPlanGroupScreen.id: (context) => MealPlanGroupScreen(),
  AboutScreen.id: (context) => AboutScreen(),
  // WebLandingPage.id: (context) => WebLandingPage(),
  ChangelogScreen.id: (context) => ChangelogScreen(),
  OCROverviewImageScreen.id: (context) => OCROverviewImageScreen(),
  OCRIngredientsImageScreen.id: (context) => OCRIngredientsImageScreen(),
  OCRInstructionsImageScreen.id: (context) => OCRInstructionsImageScreen(),
  ShoppingListSettingsScreen.id: (context) => ShoppingListSettingsScreen(),
  ErrorLogScreen.id: (context) => ErrorLogScreen(),
  LiveCameraScannerScreen.id: (context) => LiveCameraScannerScreen()
};
