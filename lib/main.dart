import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/collections/share_account_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_group_screen.dart';
import 'package:cookly/screens/settings/about_screen.dart';
import 'package:cookly/screens/web/web_landing_screen.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:cookly/screens/groups/recipe_group.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/new_ingredient_screen.dart';
import 'package:cookly/screens/settings/export_settings_screen.dart';
import 'package:cookly/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookly/screens/settings/ocr_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/settings/theme_settings_screen.dart';
import 'package:cookly/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/screens/web/web_login.dart';
import 'package:cookly/screens/web_login_app.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'de'],
  );

  setupServiceLocator();
  await GetIt.I.allReady();

  runApp(
    LocalizedApp(
      delegate,
      ProviderChainApp(),
    ),
  );
}

class ProviderChainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: CooklyMaterialApp(localizationDelegate: localizationDelegate),
      ),
    );
  }
}

class CooklyMaterialApp extends StatelessWidget {
  const CooklyMaterialApp({
    @required this.localizationDelegate,
  });

  final LocalizationDelegate localizationDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: translate(Keys.App_Title),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        localizationDelegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      locale: localizationDelegate.currentLocale,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeModel>(context).current,
      navigatorKey: sl.get<NavigatorService>().navigatorKey,
      initialRoute: kIsWeb ? WebLandingPage.id : HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WebLoginScreen.id: (context) => WebLoginScreen(),
        RecipeScreen.id: (context) => RecipeScreen(),
        NewRecipeScreen.id: (context) => NewRecipeScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        MealPlanScreen.id: (context) => MealPlanScreen(),
        OCRTestScreen.id: (context) => OCRTestScreen(),
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
        ShoppingListOverviewScreen.id: (context) =>
            ShoppingListOverviewScreen(),
        ShoppingListDetailScreen.id: (context) => ShoppingListDetailScreen(),
        RecipeGroupScreen.id: (context) => RecipeGroupScreen(),
        ShareAccountScreen.id: (context) => ShareAccountScreen(),
        MealPlanGroupScreen.id: (context) => MealPlanGroupScreen(),
        AboutScreen.id: (context) => AboutScreen(),
        WebLandingPage.id: (context) => WebLandingPage(),
      },
    );
  }
}
