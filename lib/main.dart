import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/settings/camera.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/new_ingredient_screen.dart';
import 'package:cookly/screens/settings/ocr_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
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
  runApp(
    LocalizedApp(
      delegate,
      CooklyApp(),
    ),
  );
}

class CooklyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // change notifier provider at root level to enable access to the app profile from everywhere in the app
    // todo future builder hier, um zu verhindern dass null zurückgeliefert wird
    // warten bis DataStore initialisiert wurde!!

    var localizationDelegate = LocalizedApp.of(context).delegate;

    print('Cookly App build method called');

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: FutureBuilder(
        future: GetIt.I.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ChangeNotifierProvider(
              create: (BuildContext context) {
                return sl.get<DataStore>().appProfile;
              },
              child: MaterialApp(
                title: translate(Keys.App_Title),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  localizationDelegate
                ],
                supportedLocales: localizationDelegate.supportedLocales,
                locale: localizationDelegate.currentLocale,
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark(),
                initialRoute: HomeScreen.id,
                routes: {
                  HomeScreen.id: (context) => HomeScreen(),
                  RecipeScreen.id: (context) => RecipeScreen(),
                  NewRecipeScreen.id: (context) => NewRecipeScreen(),
                  SettingsScreen.id: (context) => SettingsScreen(),
                  OCRTestScreen.id: (context) => OCRTestScreen(),
                  OnBoardingScreen.id: (context) => OnBoardingScreen(),
                  MyHomePage.id: (context) => MyHomePage(),
                  RecipeListScreen.id: (context) => RecipeListScreen(),
                  RecipeSelectionScreen.id: (context) =>
                      RecipeSelectionScreen(),
                  NewIngredientScreen.id: (context) => NewIngredientScreen(),
                },
              ),
            );
          } else {
            // not yet ready - local json being processed
            return Center(
              child: Container(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
