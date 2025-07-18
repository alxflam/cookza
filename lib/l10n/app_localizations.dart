import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @functionsAddRecipe.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get functionsAddRecipe;

  /// No description provided for @functionsFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get functionsFavorites;

  /// No description provided for @functionsListRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get functionsListRecipes;

  /// No description provided for @functionsShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get functionsShoppingList;

  /// No description provided for @functionsMealPlanner.
  ///
  /// In en, this message translates to:
  /// **'Meal Planner'**
  String get functionsMealPlanner;

  /// No description provided for @functionsLeftovers.
  ///
  /// In en, this message translates to:
  /// **'Leftover Reuse'**
  String get functionsLeftovers;

  /// No description provided for @functionsTextRecognition.
  ///
  /// In en, this message translates to:
  /// **'Text Recognition'**
  String get functionsTextRecognition;

  /// No description provided for @createRecipe.
  ///
  /// In en, this message translates to:
  /// **'Create Recipe'**
  String get createRecipe;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get editRecipe;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get recipeName;

  /// No description provided for @recipeDesc.
  ///
  /// In en, this message translates to:
  /// **'Recipe Description'**
  String get recipeDesc;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'hard'**
  String get difficultyHard;

  /// No description provided for @tagsVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get tagsVegan;

  /// No description provided for @tagsVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get tagsVegetarian;

  /// No description provided for @tagsMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get tagsMeat;

  /// No description provided for @tagsFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get tagsFish;

  /// Servings
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Serving}other{Servings}}'**
  String servings(int count);

  /// No description provided for @missingIngredientName.
  ///
  /// In en, this message translates to:
  /// **'Assign an ingredient name'**
  String get missingIngredientName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @unitLongPlural.
  ///
  /// In en, this message translates to:
  /// **'Units of Measure'**
  String get unitLongPlural;

  /// Ingredient
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Ingredient}other{Ingredients}}'**
  String ingredient(int count);

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themeTitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeDark;

  /// No description provided for @addRow.
  ///
  /// In en, this message translates to:
  /// **'Add Row'**
  String get addRow;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @addImageLong.
  ///
  /// In en, this message translates to:
  /// **'Add an image from the gallery or take a picture'**
  String get addImageLong;

  /// Recipes plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Recipe}other{Recipes}}'**
  String recipe(int count);

  /// results plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Result}other{Results}}'**
  String result(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareAs.
  ///
  /// In en, this message translates to:
  /// **'Share as'**
  String get shareAs;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm delete
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete {topic}?'**
  String confirmDelete(String topic);

  /// No description provided for @confirmDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete all your Cookza data?'**
  String get confirmDeleteAll;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @parseErrorRecipe.
  ///
  /// In en, this message translates to:
  /// **'Can not parse the file'**
  String get parseErrorRecipe;

  /// No description provided for @saveRecipeValidation.
  ///
  /// In en, this message translates to:
  /// **'Could not save recipe'**
  String get saveRecipeValidation;

  /// No description provided for @assignRecipeName.
  ///
  /// In en, this message translates to:
  /// **'Assign a recipe name'**
  String get assignRecipeName;

  /// No description provided for @assignRecipeDuration.
  ///
  /// In en, this message translates to:
  /// **'Assign a recipe duration'**
  String get assignRecipeDuration;

  /// No description provided for @assignRecipeDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Assign a recipe difficulty'**
  String get assignRecipeDifficulty;

  /// No description provided for @assignRecipeGroup.
  ///
  /// In en, this message translates to:
  /// **'Assign a recipe group'**
  String get assignRecipeGroup;

  /// No description provided for @assignIngredients.
  ///
  /// In en, this message translates to:
  /// **'There are no ingredients assigned to the recipe'**
  String get assignIngredients;

  /// No description provided for @assignServings.
  ///
  /// In en, this message translates to:
  /// **'Assign a valid servings size'**
  String get assignServings;

  /// No description provided for @assignInstructions.
  ///
  /// In en, this message translates to:
  /// **'There are no instructions assigned to the recipe'**
  String get assignInstructions;

  /// No description provided for @assignEmptyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Empty instructions are assigned'**
  String get assignEmptyInstructions;

  /// No description provided for @selectRecipes.
  ///
  /// In en, this message translates to:
  /// **'Select Recipes'**
  String get selectRecipes;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @web.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get web;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leaveGroup;

  /// Confirm leave
  ///
  /// In en, this message translates to:
  /// **'Do you really want to leave {name}?'**
  String confirmLeave(String name);

  /// No description provided for @shareAccount.
  ///
  /// In en, this message translates to:
  /// **'Share Account'**
  String get shareAccount;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file was selected'**
  String get noFileSelected;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'The selected file does not exist'**
  String get fileNotFound;

  /// No description provided for @recipeGroup.
  ///
  /// In en, this message translates to:
  /// **'Recipe Group'**
  String get recipeGroup;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroup;

  /// No description provided for @singleMember.
  ///
  /// In en, this message translates to:
  /// **'You\'re the only member of this group'**
  String get singleMember;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Logout from all devices'**
  String get logoutAllDevices;

  /// No description provided for @noRecipesFound.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFound;

  /// No description provided for @removeRecipe.
  ///
  /// In en, this message translates to:
  /// **'Remove recipe'**
  String get removeRecipe;

  /// No description provided for @referToRecipe.
  ///
  /// In en, this message translates to:
  /// **'Refer to recipe'**
  String get referToRecipe;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @mealPlanSelect.
  ///
  /// In en, this message translates to:
  /// **'Select or create a meal plan group'**
  String get mealPlanSelect;

  /// No description provided for @mealPlanAddNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get mealPlanAddNote;

  /// No description provided for @mealPlanAddRecipe.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get mealPlanAddRecipe;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'There are no items in your shopping list.'**
  String get noItems;

  /// No description provided for @noShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'There are no shopping lists.'**
  String get noShoppingLists;

  /// No description provided for @noMealPlan.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created a meal plan yet'**
  String get noMealPlan;

  /// No description provided for @mandatoryRecipeGroupNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No recipe group available'**
  String get mandatoryRecipeGroupNotAvailable;

  /// No description provided for @createMandatoryRecipeGroup.
  ///
  /// In en, this message translates to:
  /// **'Every recipe needs to be assigned to a recipe group. Therefore create a recipe group before trying to create a recipe.'**
  String get createMandatoryRecipeGroup;

  /// No description provided for @noRecipeGroupSelected.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected a recipe group'**
  String get noRecipeGroupSelected;

  /// No description provided for @missingRecipeAccess.
  ///
  /// In en, this message translates to:
  /// **'The meal plan contains recipes from groups you\'re not a member of. Therefore the shopping list can\'t be generated.'**
  String get missingRecipeAccess;

  /// No description provided for @noSimilarRecipes.
  ///
  /// In en, this message translates to:
  /// **'No similar recipes found'**
  String get noSimilarRecipes;

  /// No description provided for @weekDurationDesc.
  ///
  /// In en, this message translates to:
  /// **'Set how many weeks are available for planning.'**
  String get weekDurationDesc;

  /// No description provided for @oneWeek.
  ///
  /// In en, this message translates to:
  /// **'One Week'**
  String get oneWeek;

  /// No description provided for @twoWeeks.
  ///
  /// In en, this message translates to:
  /// **'Two Weeks'**
  String get twoWeeks;

  /// No description provided for @stdServingsDesc.
  ///
  /// In en, this message translates to:
  /// **'The standard servings size is being used to determine the servings size for newly added meals. You can always adjust the servings size for any meal later.'**
  String get stdServingsDesc;

  /// No description provided for @stdServings.
  ///
  /// In en, this message translates to:
  /// **'Standard Servings Size'**
  String get stdServings;

  /// No description provided for @changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Cookza enables you to store, collect and share your favourite recipes in a data-privacy friendly manner'**
  String get appDescription;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Alexander Flammer'**
  String get copyright;

  /// No description provided for @localImages.
  ///
  /// In en, this message translates to:
  /// **'Local Images'**
  String get localImages;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @json.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get json;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image deleted'**
  String get imageDeleted;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacyStatement.
  ///
  /// In en, this message translates to:
  /// **'Data Privacy Statement'**
  String get privacyStatement;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get deleteAllDataSuccess;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help and Feedback'**
  String get supportSubtitle;

  /// No description provided for @errorLog.
  ///
  /// In en, this message translates to:
  /// **'Error Log'**
  String get errorLog;

  /// No description provided for @noErrorLogEntry.
  ///
  /// In en, this message translates to:
  /// **'The error log is empty'**
  String get noErrorLogEntry;

  /// Importing X recipes
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Importing {count} recipe} other{Importing {count} recipes}}'**
  String importingRecipes(int count);

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR-Code'**
  String get scanQRCode;

  /// No description provided for @noQRCodeDetected.
  ///
  /// In en, this message translates to:
  /// **'Could not detect any QR-Code.'**
  String get noQRCodeDetected;

  /// No description provided for @tryAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Please try another image.'**
  String get tryAnotherImage;

  /// No description provided for @invalidQRCode.
  ///
  /// In en, this message translates to:
  /// **'The scanned QR-Code is not supported.'**
  String get invalidQRCode;

  /// A user has been added
  ///
  /// In en, this message translates to:
  /// **'The use {name} has been added.'**
  String addedUser(String name);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUser;

  /// No description provided for @selfUser.
  ///
  /// In en, this message translates to:
  /// **'That\'s myself'**
  String get selfUser;

  /// No description provided for @addMeToGroup.
  ///
  /// In en, this message translates to:
  /// **'Add me to your groups on Cookza'**
  String get addMeToGroup;

  /// No description provided for @shareQRCodeSubject.
  ///
  /// In en, this message translates to:
  /// **'Cookza QR-Code'**
  String get shareQRCodeSubject;

  /// No description provided for @validationEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number'**
  String get validationEnterNumber;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cookza!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Cookza let\'s you manage all your favorite recipes in a single app'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your recipes'**
  String get onboardingRecipeTitle;

  /// No description provided for @onboardingRecipeBody.
  ///
  /// In en, this message translates to:
  /// **'Create recipes manually or let Cookza process a picture or a webpage to retrieve a recipe. Organize your recipes in groups and add friends to your recipe groups to share them'**
  String get onboardingRecipeBody;

  /// No description provided for @onboardingMealPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Planner'**
  String get onboardingMealPlanTitle;

  /// No description provided for @onboardingMealPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Plan the meals for the whole week and share your meal plan with your household members.'**
  String get onboardingMealPlanBody;

  /// No description provided for @onboardingShoppingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get onboardingShoppingListTitle;

  /// No description provided for @onboardingShoppingListBody.
  ///
  /// In en, this message translates to:
  /// **'Generate a shopping list for your meal plan and share it'**
  String get onboardingShoppingListBody;

  /// No description provided for @onboardingMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Much more to explore'**
  String get onboardingMoreTitle;

  /// No description provided for @onboardingMoreBody.
  ///
  /// In en, this message translates to:
  /// **'You can also search for similar recipes, find recipes by ingredients and share recipes with other cookly users - by PDF, Text or by adding them to your recipe groups'**
  String get onboardingMoreBody;

  /// No description provided for @onboardingDataPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Data privacy'**
  String get onboardingDataPrivacyTitle;

  /// No description provided for @onboardingDataPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'You don\'t need to register with your mail or mobile phone number.'**
  String get onboardingDataPrivacyBody;

  /// No description provided for @onboardingAcceptData.
  ///
  /// In en, this message translates to:
  /// **'Cookza stores your data on a cloud database provided by Google in europe.'**
  String get onboardingAcceptData;

  /// No description provided for @onboardingAcceptAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Users are authenticated anonymously, therefore no Login credentials are required.'**
  String get onboardingAcceptAuthentication;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @readAndAccept.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the '**
  String get readAndAccept;

  /// Favorite recipe not existing
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{There are no recipes rated with at least {count} star} other{There are no recipes rated with at least {count} stars}}'**
  String favoriteNotExisting(int count);

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCode;

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{mm}other{mm}}'**
  String uomMMT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{cm}other{cm}}'**
  String uomCMT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{m}other{m}}'**
  String uomMTR(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{g}other{g}}'**
  String uomGRM(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{kg}other{kg}}'**
  String uomKGM(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{ml}other{ml}}'**
  String uomMLT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{cl}other{cl}}'**
  String uomCLT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{dl}other{dl}}'**
  String uomDLT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{l}other{l}}'**
  String uomLTR(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{piece}other{pieces}}'**
  String uomH87(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{cup}other{cups}}'**
  String uomG21(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{tablespoon}other{tablespoons}}'**
  String uomG24(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{teaspoon}other{teaspoons}}'**
  String uomG25(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{bag}other{bag}}'**
  String uomBG(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{leaf}other{leafs}}'**
  String uomLEF(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{bunch}other{bunches}}'**
  String uomX2(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{drop}other{drops}}'**
  String uomX4(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{can}other{cans}}'**
  String uomCA(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{bottle}other{bottles}}'**
  String uomBO(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{stick}other{sticks}}'**
  String uomSTC(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{pair}other{pairs}}'**
  String uomPR(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{packets}other{packets}}'**
  String uomPA(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{portion}other{portions}}'**
  String uomPTN(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{bar}other{bars}}'**
  String uomBR(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{roll}other{rolls}}'**
  String uomRO(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{shot}other{shots}}'**
  String uom14(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{strip}other{strips}}'**
  String uomSR(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{tube}other{tubes}}'**
  String uomTU(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{slice}other{slices}}'**
  String uomSLI(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{glass}other{glasses}}'**
  String uomGLA(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{handful}other{handful}}'**
  String uomHAN(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{pinch}other{pinches}}'**
  String uomPIN(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{bowl}other{bowls}}'**
  String uomBOW(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{stem}other{stems}}'**
  String uomSTE(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{cube}other{cubes}}'**
  String uomCUB(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{clove}other{cloves}}'**
  String uomCLO(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{root}other{roots}}'**
  String uomROT(int count);

  /// uom plural
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{twig}other{twigs}}'**
  String uomTWG(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
