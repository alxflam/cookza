// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get functionsAddRecipe => 'New Recipe';

  @override
  String get functionsFavorites => 'Favorites';

  @override
  String get functionsListRecipes => 'Recipes';

  @override
  String get functionsShoppingList => 'Shopping List';

  @override
  String get functionsMealPlanner => 'Meal Planner';

  @override
  String get functionsLeftovers => 'Leftover Reuse';

  @override
  String get functionsTextRecognition => 'Text Recognition';

  @override
  String get createRecipe => 'Create Recipe';

  @override
  String get editRecipe => 'Edit Recipe';

  @override
  String get recipeName => 'Recipe Name';

  @override
  String get recipeDesc => 'Recipe Description';

  @override
  String get duration => 'Duration';

  @override
  String get min => 'min';

  @override
  String get difficultyEasy => 'easy';

  @override
  String get difficultyMedium => 'medium';

  @override
  String get difficultyHard => 'hard';

  @override
  String get tagsVegan => 'Vegan';

  @override
  String get tagsVegetarian => 'Vegetarian';

  @override
  String get tagsMeat => 'Meat';

  @override
  String get tagsFish => 'Fish';

  @override
  String servings(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Servings',
      one: 'Serving',
    );
    return '$_temp0';
  }

  @override
  String get missingIngredientName => 'Assign an ingredient name';

  @override
  String get amount => 'Amount';

  @override
  String get unit => 'Unit';

  @override
  String get unitLongPlural => 'Units of Measure';

  @override
  String ingredient(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ingredients',
      one: 'Ingredient',
    );
    return '$_temp0';
  }

  @override
  String get instructions => 'Instructions';

  @override
  String get themeTitle => 'Themes';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get addRow => 'Add Row';

  @override
  String get addIngredient => 'Add Ingredient';

  @override
  String get addImageLong => 'Add an image from the gallery or take a picture';

  @override
  String recipe(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recipes',
      one: 'Recipe',
    );
    return '$_temp0';
  }

  @override
  String result(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Results',
      one: 'Result',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'Settings';

  @override
  String get share => 'Share';

  @override
  String get shareAs => 'Share as';

  @override
  String get copy => 'Copy';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String confirmDelete(String topic) {
    return 'Do you really want to delete $topic?';
  }

  @override
  String get confirmDeleteAll =>
      'Do you really want to delete all your Cookza data?';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get parseErrorRecipe => 'Can not parse the file';

  @override
  String get saveRecipeValidation => 'Could not save recipe';

  @override
  String get assignRecipeName => 'Assign a recipe name';

  @override
  String get assignRecipeDuration => 'Assign a recipe duration';

  @override
  String get assignRecipeDifficulty => 'Assign a recipe difficulty';

  @override
  String get assignRecipeGroup => 'Assign a recipe group';

  @override
  String get assignIngredients =>
      'There are no ingredients assigned to the recipe';

  @override
  String get assignServings => 'Assign a valid servings size';

  @override
  String get assignInstructions =>
      'There are no instructions assigned to the recipe';

  @override
  String get assignEmptyInstructions => 'Empty instructions are assigned';

  @override
  String get selectRecipes => 'Select Recipes';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get web => 'Web';

  @override
  String get addUser => 'Add User';

  @override
  String get leaveGroup => 'Leave Group';

  @override
  String confirmLeave(String name) {
    return 'Do you really want to leave $name?';
  }

  @override
  String get shareAccount => 'Share Account';

  @override
  String get noFileSelected => 'No file was selected';

  @override
  String get fileNotFound => 'The selected file does not exist';

  @override
  String get recipeGroup => 'Recipe Group';

  @override
  String get createGroup => 'Create Group';

  @override
  String get editGroup => 'Edit Group';

  @override
  String get singleMember => 'You\'re the only member of this group';

  @override
  String get groupName => 'Group Name';

  @override
  String get logout => 'Logout';

  @override
  String get logoutAllDevices => 'Logout from all devices';

  @override
  String get noRecipesFound => 'No recipes found';

  @override
  String get removeRecipe => 'Remove recipe';

  @override
  String get referToRecipe => 'Refer to recipe';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get mealPlanSelect => 'Select or create a meal plan group';

  @override
  String get mealPlanAddNote => 'Note';

  @override
  String get mealPlanAddRecipe => 'Recipe';

  @override
  String get from => 'From';

  @override
  String get until => 'Until';

  @override
  String get addItem => 'Add Item';

  @override
  String get noItems => 'There are no items in your shopping list.';

  @override
  String get noShoppingLists => 'There are no shopping lists.';

  @override
  String get noMealPlan => 'You haven\'t created a meal plan yet';

  @override
  String get mandatoryRecipeGroupNotAvailable => 'No recipe group available';

  @override
  String get createMandatoryRecipeGroup =>
      'Every recipe needs to be assigned to a recipe group. Therefore create a recipe group before trying to create a recipe.';

  @override
  String get noRecipeGroupSelected => 'You haven\'t selected a recipe group';

  @override
  String get missingRecipeAccess =>
      'The meal plan contains recipes from groups you\'re not a member of. Therefore the shopping list can\'t be generated.';

  @override
  String get noSimilarRecipes => 'No similar recipes found';

  @override
  String get weekDurationDesc =>
      'Set how many weeks are available for planning.';

  @override
  String get oneWeek => 'One Week';

  @override
  String get twoWeeks => 'Two Weeks';

  @override
  String get stdServingsDesc =>
      'The standard servings size is being used to determine the servings size for newly added meals. You can always adjust the servings size for any meal later.';

  @override
  String get stdServings => 'Standard Servings Size';

  @override
  String get changelog => 'Changelog';

  @override
  String get getStarted => 'Get Started';

  @override
  String get appDescription =>
      'Cookza enables you to store, collect and share your favourite recipes in a data-privacy friendly manner';

  @override
  String get copyright => '© 2025 Alexander Flammer';

  @override
  String get localImages => 'Local Images';

  @override
  String get pdf => 'PDF';

  @override
  String get json => 'JSON';

  @override
  String get backup => 'Backup';

  @override
  String get text => 'Text';

  @override
  String get imageDeleted => 'Image deleted';

  @override
  String get legal => 'Legal';

  @override
  String get privacyStatement => 'Data Privacy Statement';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllDataSuccess => 'All data deleted';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle => 'Help and Feedback';

  @override
  String get errorLog => 'Error Log';

  @override
  String get noErrorLogEntry => 'The error log is empty';

  @override
  String importingRecipes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importing $countString recipes',
      one: 'Importing $countString recipe',
    );
    return '$_temp0';
  }

  @override
  String get scanQRCode => 'Scan QR-Code';

  @override
  String get noQRCodeDetected => 'Could not detect any QR-Code.';

  @override
  String get tryAnotherImage => 'Please try another image.';

  @override
  String get invalidQRCode => 'The scanned QR-Code is not supported.';

  @override
  String addedUser(String name) {
    return 'The use $name has been added.';
  }

  @override
  String get error => 'Error';

  @override
  String get unknownUser => 'Unknown';

  @override
  String get selfUser => 'That\'s myself';

  @override
  String get addMeToGroup => 'Add me to your groups on Cookza';

  @override
  String get shareQRCodeSubject => 'Cookza QR-Code';

  @override
  String get validationEnterNumber => 'Please enter a number';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Cookza!';

  @override
  String get onboardingWelcomeBody =>
      'Cookza let\'s you manage all your favorite recipes in a single app';

  @override
  String get onboardingRecipeTitle => 'Organize your recipes';

  @override
  String get onboardingRecipeBody =>
      'Create recipes manually or let Cookza process a picture or a webpage to retrieve a recipe. Organize your recipes in groups and add friends to your recipe groups to share them';

  @override
  String get onboardingMealPlanTitle => 'Meal Planner';

  @override
  String get onboardingMealPlanBody =>
      'Plan the meals for the whole week and share your meal plan with your household members.';

  @override
  String get onboardingShoppingListTitle => 'Shopping List';

  @override
  String get onboardingShoppingListBody =>
      'Generate a shopping list for your meal plan and share it';

  @override
  String get onboardingMoreTitle => 'Much more to explore';

  @override
  String get onboardingMoreBody =>
      'You can also search for similar recipes, find recipes by ingredients and share recipes with other cookly users - by PDF, Text or by adding them to your recipe groups';

  @override
  String get onboardingDataPrivacyTitle => 'Data privacy';

  @override
  String get onboardingDataPrivacyBody =>
      'You don\'t need to register with your mail or mobile phone number.';

  @override
  String get onboardingAcceptData =>
      'Cookza stores your data on a cloud database provided by Google in europe.';

  @override
  String get onboardingAcceptAuthentication =>
      'Users are authenticated anonymously, therefore no Login credentials are required.';

  @override
  String get accept => 'Accept';

  @override
  String get readAndAccept => 'I have read and accept the ';

  @override
  String favoriteNotExisting(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'There are no recipes rated with at least $countString stars',
      one: 'There are no recipes rated with at least $countString star',
    );
    return '$_temp0';
  }

  @override
  String get sourceCode => 'Source Code';

  @override
  String uomMMT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mm',
      one: 'mm',
    );
    return '$_temp0';
  }

  @override
  String uomCMT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cm',
      one: 'cm',
    );
    return '$_temp0';
  }

  @override
  String uomMTR(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'm',
      one: 'm',
    );
    return '$_temp0';
  }

  @override
  String uomGRM(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'g',
      one: 'g',
    );
    return '$_temp0';
  }

  @override
  String uomKGM(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kg',
      one: 'kg',
    );
    return '$_temp0';
  }

  @override
  String uomMLT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ml',
      one: 'ml',
    );
    return '$_temp0';
  }

  @override
  String uomCLT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cl',
      one: 'cl',
    );
    return '$_temp0';
  }

  @override
  String uomDLT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dl',
      one: 'dl',
    );
    return '$_temp0';
  }

  @override
  String uomLTR(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'l',
      one: 'l',
    );
    return '$_temp0';
  }

  @override
  String uomH87(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pieces',
      one: 'piece',
    );
    return '$_temp0';
  }

  @override
  String uomG21(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cups',
      one: 'cup',
    );
    return '$_temp0';
  }

  @override
  String uomG24(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tablespoons',
      one: 'tablespoon',
    );
    return '$_temp0';
  }

  @override
  String uomG25(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'teaspoons',
      one: 'teaspoon',
    );
    return '$_temp0';
  }

  @override
  String uomBG(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bag',
      one: 'bag',
    );
    return '$_temp0';
  }

  @override
  String uomLEF(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'leafs',
      one: 'leaf',
    );
    return '$_temp0';
  }

  @override
  String uomX2(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bunches',
      one: 'bunch',
    );
    return '$_temp0';
  }

  @override
  String uomX4(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'drops',
      one: 'drop',
    );
    return '$_temp0';
  }

  @override
  String uomCA(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cans',
      one: 'can',
    );
    return '$_temp0';
  }

  @override
  String uomBO(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bottles',
      one: 'bottle',
    );
    return '$_temp0';
  }

  @override
  String uomSTC(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sticks',
      one: 'stick',
    );
    return '$_temp0';
  }

  @override
  String uomPR(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pairs',
      one: 'pair',
    );
    return '$_temp0';
  }

  @override
  String uomPA(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'packets',
      one: 'packets',
    );
    return '$_temp0';
  }

  @override
  String uomPTN(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'portions',
      one: 'portion',
    );
    return '$_temp0';
  }

  @override
  String uomBR(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bars',
      one: 'bar',
    );
    return '$_temp0';
  }

  @override
  String uomRO(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'rolls',
      one: 'roll',
    );
    return '$_temp0';
  }

  @override
  String uom14(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'shots',
      one: 'shot',
    );
    return '$_temp0';
  }

  @override
  String uomSR(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'strips',
      one: 'strip',
    );
    return '$_temp0';
  }

  @override
  String uomTU(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tubes',
      one: 'tube',
    );
    return '$_temp0';
  }

  @override
  String uomSLI(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'slices',
      one: 'slice',
    );
    return '$_temp0';
  }

  @override
  String uomGLA(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'glasses',
      one: 'glass',
    );
    return '$_temp0';
  }

  @override
  String uomHAN(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'handful',
      one: 'handful',
    );
    return '$_temp0';
  }

  @override
  String uomPIN(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pinches',
      one: 'pinch',
    );
    return '$_temp0';
  }

  @override
  String uomBOW(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bowls',
      one: 'bowl',
    );
    return '$_temp0';
  }

  @override
  String uomSTE(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'stems',
      one: 'stem',
    );
    return '$_temp0';
  }

  @override
  String uomCUB(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cubes',
      one: 'cube',
    );
    return '$_temp0';
  }

  @override
  String uomCLO(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cloves',
      one: 'clove',
    );
    return '$_temp0';
  }

  @override
  String uomROT(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'roots',
      one: 'root',
    );
    return '$_temp0';
  }

  @override
  String uomTWG(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'twigs',
      one: 'twig',
    );
    return '$_temp0';
  }
}
