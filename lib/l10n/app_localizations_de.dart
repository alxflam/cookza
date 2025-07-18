// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get functionsAddRecipe => 'Neues Rezept';

  @override
  String get functionsFavorites => 'Favoriten';

  @override
  String get functionsListRecipes => 'Rezepte';

  @override
  String get functionsShoppingList => 'Einkaufsliste';

  @override
  String get functionsMealPlanner => 'Essensplan';

  @override
  String get functionsLeftovers => 'Resteverwertung';

  @override
  String get functionsTextRecognition => 'Texterkennung';

  @override
  String get createRecipe => 'Rezept erstellen';

  @override
  String get editRecipe => 'Rezept bearbeiten';

  @override
  String get recipeName => 'Name';

  @override
  String get recipeDesc => 'Kurzbeschreibung';

  @override
  String get duration => 'Dauer';

  @override
  String get min => 'min';

  @override
  String get difficultyEasy => 'leicht';

  @override
  String get difficultyMedium => 'mittel';

  @override
  String get difficultyHard => 'schwer';

  @override
  String get tagsVegan => 'Vegan';

  @override
  String get tagsVegetarian => 'Vegetarisch';

  @override
  String get tagsMeat => 'Fleisch';

  @override
  String get tagsFish => 'Fisch';

  @override
  String servings(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Portionen',
      one: 'Portion',
    );
    return '$_temp0';
  }

  @override
  String get missingIngredientName =>
      'Der Name der Zutat muss angegeben werden';

  @override
  String get amount => 'Menge';

  @override
  String get unit => 'Einheit';

  @override
  String get unitLongPlural => 'Mengeneinheiten';

  @override
  String ingredient(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zutaten',
      one: 'Zutat',
    );
    return '$_temp0';
  }

  @override
  String get instructions => 'Zubereitung';

  @override
  String get themeTitle => 'Themes';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get addRow => 'Zeile hinzufügen';

  @override
  String get addIngredient => 'Zutat hinzufügen';

  @override
  String get addImageLong => 'Bild hinzufügen';

  @override
  String recipe(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rezepte',
      one: 'Rezept',
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
      other: 'Ergebnisse',
      one: 'Ergebnis',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get share => 'Teilen';

  @override
  String get shareAs => 'Teilen als';

  @override
  String get copy => 'Kopieren';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get search => 'Suchen';

  @override
  String get rename => 'Umbennen';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String confirmDelete(String topic) {
    return 'Soll $topic wirklich gelöscht werden?';
  }

  @override
  String get confirmDeleteAll =>
      'Sollen wirklich alle Cookza Daten gelöscht werden?';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get parseErrorRecipe => 'Datei kann nicht importiert werden';

  @override
  String get saveRecipeValidation => 'Rezept konnte nicht gespeichert werden';

  @override
  String get assignRecipeName => 'Ein Rezeptname muss angegeben werden';

  @override
  String get assignRecipeDuration =>
      'Eine Zubereitungsdauer muss angegeben werden';

  @override
  String get assignRecipeDifficulty =>
      'Eine Schwierigkeitsstufe muss angegeben werden';

  @override
  String get assignRecipeGroup => 'Eine Rezeptgruppe muss angegeben werden';

  @override
  String get assignIngredients => 'Das Rezept enthält keine Zutaten';

  @override
  String get assignServings => 'Eine Portionsgröße muss angegeben werden';

  @override
  String get assignInstructions =>
      'Das Rezept enthält keine Zubereitungsanweisungen';

  @override
  String get assignEmptyInstructions =>
      'Das Rezept enthält leere Zubereitungsanweisungen';

  @override
  String get selectRecipes => 'Rezepte auswählen';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get deselectAll => 'Alle abwählen';

  @override
  String get web => 'Web';

  @override
  String get addUser => 'User hinzufügen';

  @override
  String get leaveGroup => 'Gruppe verlassen';

  @override
  String confirmLeave(String name) {
    return '$name wirklich verlassen?';
  }

  @override
  String get shareAccount => 'Account teilen';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt';

  @override
  String get fileNotFound => 'Die ausgewählte Datei wurde nicht gefunden';

  @override
  String get recipeGroup => 'Rezeptgruppe';

  @override
  String get createGroup => 'Gruppe erstellen';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get singleMember => 'Sie sind das einzige Mitglied dieser Gruppe';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutAllDevices => 'Von allen Geräten abmelden';

  @override
  String get noRecipesFound => 'Keine Rezepte gefunden';

  @override
  String get removeRecipe => 'Rezept entfernen';

  @override
  String get referToRecipe => 'Rezept referenzieren';

  @override
  String get enterUsername => 'Benutzername eingeben';

  @override
  String get mealPlanSelect => 'Gruppe auswählen oder erstellen';

  @override
  String get mealPlanAddNote => 'Notiz';

  @override
  String get mealPlanAddRecipe => 'Rezept';

  @override
  String get from => 'Von';

  @override
  String get until => 'Bis';

  @override
  String get addItem => 'Neuer Eintrag';

  @override
  String get noItems => 'Die Einkaufsliste enthält keine Einträge.';

  @override
  String get noShoppingLists => 'Du hast noch keine Einkaufslisten erstellt.';

  @override
  String get noMealPlan => 'Erstelle zuerst einen Essensplan';

  @override
  String get mandatoryRecipeGroupNotAvailable => 'Keine Rezeptgruppe vefügbar';

  @override
  String get createMandatoryRecipeGroup =>
      'Jedes Rezept muss einer Gruppe zugeordnet werden. Erstelle daher zuerst eine Rezeptgruppe.';

  @override
  String get noRecipeGroupSelected => 'Wähle eine Rezeptgruppe aus';

  @override
  String get missingRecipeAccess =>
      'Der Essensplan enthält Rezepte aus Gruppen denen du nicht angehörst. Die Einkaufsliste kann daher nicht erstellt werden.';

  @override
  String get noSimilarRecipes => 'Es wurden keine ähnlichen Rezepte gefunden';

  @override
  String get weekDurationDesc =>
      'Anzahl der Wochen, die im Essensplaner verfügbar sind.';

  @override
  String get oneWeek => 'Eine Woche';

  @override
  String get twoWeeks => 'Zwei Wochen';

  @override
  String get stdServingsDesc =>
      'Die Standardportionsgröße wird für neu hinzugefügte Mahlzeiten verwendet. Die Anzahl der Portionen kann anschließend jederzeit geändert werden.';

  @override
  String get stdServings => 'Standard Portionsgröße';

  @override
  String get changelog => 'Changelog';

  @override
  String get getStarted => 'Erste Schritte';

  @override
  String get appDescription =>
      'Cookza ermöglicht es Ihnen, Ihre Lieblingsrezepte datenschutzfreundlich zu speichern, zu sammeln und zu teilen';

  @override
  String get copyright => '© 2025 Alexander Flammer';

  @override
  String get localImages => 'Lokale Bilder';

  @override
  String get pdf => 'PDF';

  @override
  String get json => 'JSON';

  @override
  String get backup => 'Backup';

  @override
  String get text => 'Text';

  @override
  String get imageDeleted => 'Bild gelöscht';

  @override
  String get legal => 'Rechtliches';

  @override
  String get privacyStatement => 'Datenschutzerklärung';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get deleteAllData => 'Alle Daten löschen';

  @override
  String get deleteAllDataSuccess => 'Alle Daten wurden gelöscht';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle => 'Hilfe und Feedback';

  @override
  String get errorLog => 'Fehlerlog';

  @override
  String get noErrorLogEntry => 'Das Fehlerlog enthält keine Einträge';

  @override
  String importingRecipes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importiere $countString Rezepte',
      one: 'Importiere $countString Rezept',
    );
    return '$_temp0';
  }

  @override
  String get scanQRCode => 'QR-Code scannen';

  @override
  String get noQRCodeDetected => 'Es wurde kein gültiger QR-Code erkannt.';

  @override
  String get tryAnotherImage => 'Wählen Sie ein anderes Bild.';

  @override
  String get invalidQRCode => 'Der erkannte QR-Code wird nicht unterstützt.';

  @override
  String addedUser(String name) {
    return 'Der Benutzer $name wurde hinzugefügt.';
  }

  @override
  String get error => 'Fehler';

  @override
  String get unknownUser => 'Unbekannt';

  @override
  String get selfUser => 'Das bin ich';

  @override
  String get addMeToGroup => 'Füge mich bei Deinen Cookza Gruppen hinzu.';

  @override
  String get shareQRCodeSubject => 'Cookza QR-Code';

  @override
  String get validationEnterNumber => 'Bitte geben Sie eine Zahl ein';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Cookza!';

  @override
  String get onboardingWelcomeBody =>
      'Mit Cookza kannst du alle deine Lieblingsrezepte in einer App verwalten.';

  @override
  String get onboardingRecipeTitle => 'Verwalte deine Rezepte';

  @override
  String get onboardingRecipeBody =>
      'Erstelle Rezepte manuell oder mit Hilfe von Texterkennung. Organisiere deine Rezepte in Gruppen und teile sie mit deinen Freunden.';

  @override
  String get onboardingMealPlanTitle => 'Essensplan';

  @override
  String get onboardingMealPlanBody =>
      'Plane deine Mahlzeiten und teile deinen Essensplan mit den Mitgliedern deines Haushaltes.';

  @override
  String get onboardingShoppingListTitle => 'Einkaufsliste';

  @override
  String get onboardingShoppingListBody =>
      'Generiere aus deinem Essensplan eine stets aktuelle Einkaufsliste und teile sie.';

  @override
  String get onboardingMoreTitle => 'Und noch viel mehr';

  @override
  String get onboardingMoreBody =>
      'Suche passende Rezepte für deine verfügbaren Zutaten oder exportiere deine Rezepte als PDF - und noch viel mehr kannst du mit Cookza machen.';

  @override
  String get onboardingDataPrivacyTitle => 'Datenschutz';

  @override
  String get onboardingDataPrivacyBody =>
      'Weder deine E-Mail-Adresse noch deine Telefonnummer werden zur Registrierung benötigt.';

  @override
  String get onboardingAcceptData =>
      'Cookza speichert deine Daten auf einer Cloud Datenbank in Europa, die von Google betrieben wird.';

  @override
  String get onboardingAcceptAuthentication =>
      'Benutzer werden anonym authentisiert, daher wird kein Benutzername oder Passwort benötigt.';

  @override
  String get accept => 'Akzeptieren';

  @override
  String get readAndAccept => 'Ich akzeptiere die ';

  @override
  String favoriteNotExisting(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Keine Rezepte mit mind. $countString Sternen bewertet',
      one: 'Keine Rezepte mit mind. $countString Stern bewertet',
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
      other: 'Stück',
      one: 'Stück',
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
      other: 'Tassen',
      one: 'Tasse',
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
      other: 'EL',
      one: 'EL',
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
      other: 'TL',
      one: 'TL',
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
      other: 'Beutel',
      one: 'Beutel',
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
      other: 'Blätter',
      one: 'Blatt',
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
      other: 'Bündel',
      one: 'Bund',
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
      other: 'Tropfen',
      one: 'Tropfen',
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
      other: 'Dosen',
      one: 'Dose',
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
      other: 'Flaschen',
      one: 'Flasche',
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
      other: 'Stangen',
      one: 'Stange',
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
      other: 'Paar',
      one: 'Paar',
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
      other: 'Päckchen',
      one: 'Päckchen',
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
      other: 'Portionen',
      one: 'Portion',
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
      other: 'Riegel',
      one: 'Riegel',
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
      other: 'Rollen',
      one: 'Rolle',
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
      other: 'Spritzer',
      one: 'Spritzer',
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
      other: 'Streifen',
      one: 'Streifen',
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
      other: 'Tuben',
      one: 'Tube',
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
      other: 'Scheiben',
      one: 'Scheibe',
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
      other: 'Gläser',
      one: 'Glas',
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
      other: 'handvoll',
      one: 'handvoll',
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
      other: 'Prise',
      one: 'Prise',
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
      other: 'Schüsseln',
      one: 'Schüssel',
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
      other: 'Stiele',
      one: 'Stiel',
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
      other: 'Würfel',
      one: 'Würfel',
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
      other: 'Zehen',
      one: 'Zehe',
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
      other: 'Wurzeln',
      one: 'Wurzel',
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
      other: 'Zweige',
      one: 'Zweig',
    );
    return '$_temp0';
  }
}
