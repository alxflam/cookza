import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/onboarding_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test('Initial state', () async {
    var cut = OnboardingModel();
    expect(cut.acceptedAll, false);
  });

  test('Set accepteed', () async {
    var cut = OnboardingModel();
    cut.termsOfUse = true;
    expect(cut.acceptedAll, false);
    expect(cut.termsOfUse, true);

    cut.privacyStatement = true;
    expect(cut.acceptedAll, true);
    expect(cut.privacyStatement, true);
  });
}
