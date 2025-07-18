import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookza/l10n/app_localizations.dart';

import '../../mocks/shared_mocks.mocks.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Onboarding shows consent screen', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(OnBoardingScreen), findsOneWidget);
    var tile = find.byIcon(Icons.arrow_forward);
    expect(tile, findsOneWidget);
    expect(find.text('Welcome to Cookza!'), findsOneWidget);

    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Organize your recipes'), findsOneWidget);

    tile = find.byIcon(Icons.arrow_forward);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Meal Planner'), findsOneWidget);

    tile = find.byIcon(Icons.arrow_forward);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Shopping List'), findsOneWidget);

    tile = find.byIcon(Icons.arrow_forward);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Much more to explore'), findsOneWidget);

    tile = find.byIcon(Icons.arrow_forward);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Data privacy'), findsOneWidget);

    tile = find.byIcon(Icons.arrow_forward);
    await tester.tap(tile);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Accept'), findsOneWidget);

    var cb = find.byType(Checkbox);
    expect(cb, findsNWidgets(2));

    await tester.tap(cb.first);
    await tester.pumpAndSettle();

    await tester.tap(cb.last);
    await tester.pumpAndSettle();

    var btn = find.byType(ElevatedButton).first;
    await tester.tap(btn);
    await tester.pumpAndSettle();

    expect(find.text('Accept'), findsNothing);
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    MaterialApp(
      routes: kRoutes,
      navigatorObservers: [observer],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: Builder(
          builder: (context) => const TestHomeScreen(),
        ),
      ),
    ),
  );
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, OnBoardingScreen.id);
      },
      child: Container(),
    );
  }
}
