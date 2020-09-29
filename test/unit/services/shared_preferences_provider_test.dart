import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  var cut = SharedPreferencesProviderImpl();
  await cut.init();

  test(
    'Date privacy statement eccepted',
    () async {
      cut.setAcceptedDataPrivacyStatement(true);
      expect(cut.acceptedDataPrivacyStatement(), true);

      cut.setAcceptedDataPrivacyStatement(false);
      expect(cut.acceptedDataPrivacyStatement(), false);
    },
  );

  test(
    'Terms of Use eccepted',
    () async {
      cut.setAcceptedTermsOfUse(true);
      expect(cut.acceptedTermsOfUse(), true);

      cut.setAcceptedTermsOfUse(false);
      expect(cut.acceptedTermsOfUse(), false);
    },
  );

  test(
    'Terms of Use eccepted',
    () async {
      var collection = '1234';
      expect(cut.getCurrentMealPlanCollection(), null);

      cut.setCurrentMealPlanCollection(collection);
      expect(cut.getCurrentMealPlanCollection(), collection);
    },
  );

  test(
    'Introduction shown',
    () async {
      expect(cut.introductionShown(), false);

      cut.setIntroductionShown(true);
      expect(cut.introductionShown(), true);
    },
  );

  test(
    'Meal plan servings size',
    () async {
      expect(cut.getMealPlanStandardServingsSize(), 2);

      cut.setMealPlanStandardServingsSize(5);
      expect(cut.getMealPlanStandardServingsSize(), 5);
    },
  );

  test(
    'Meal plan weeks',
    () async {
      expect(cut.getMealPlanWeeks(), 2);

      cut.setMealPlanWeeks(3);
      expect(cut.getMealPlanWeeks(), 3);
    },
  );

  test(
    'UoM visibility',
    () async {
      var uom = 'WHATEVER';
      expect(cut.isUnitOfMeasureVisible(uom), true);

      cut.setUnitOfMeasureVisibility(uom, false);
      expect(cut.isUnitOfMeasureVisible(uom), false);

      cut.setUnitOfMeasureVisibility(uom, true);
      expect(cut.isUnitOfMeasureVisible(uom), true);
    },
  );

  test(
    'Meal plan weeks',
    () async {
      expect(cut.getUserName(), '');

      cut.setUserName('John Doe');
      expect(cut.getUserName(), 'John Doe');
    },
  );
}
