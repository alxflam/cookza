import 'package:cookly/screens/collections/share_account_screen.dart';
import 'package:cookly/screens/groups/recipe_group.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_group_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/new_ingredient_screen.dart';
import 'package:cookly/screens/ocr_creation/ocr_stepper.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/screens/settings/about_screen.dart';
import 'package:cookly/screens/settings/changelog_screen.dart';
import 'package:cookly/screens/settings/export_settings_screen.dart';
import 'package:cookly/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/settings/theme_settings_screen.dart';
import 'package:cookly/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/screens/web/web_landing_screen.dart';
import 'package:cookly/screens/web/web_login.dart';
import 'package:cookly/screens/web_login_app.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> kRoutes = {
  HomeScreen.id: (context) => HomeScreen(),
  WebLoginScreen.id: (context) => WebLoginScreen(),
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
  WebLoginOnAppScreen.id: (context) => WebLoginOnAppScreen(),
  ShoppingListOverviewScreen.id: (context) => ShoppingListOverviewScreen(),
  ShoppingListDetailScreen.id: (context) => ShoppingListDetailScreen(),
  RecipeGroupScreen.id: (context) => RecipeGroupScreen(),
  ShareAccountScreen.id: (context) => ShareAccountScreen(),
  MealPlanGroupScreen.id: (context) => MealPlanGroupScreen(),
  AboutScreen.id: (context) => AboutScreen(),
  WebLandingPage.id: (context) => WebLandingPage(),
  OcrCreationScreen.id: (context) => OcrCreationScreen(),
  ChangelogScreen.id: (context) => ChangelogScreen(),
};