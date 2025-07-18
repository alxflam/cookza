import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookza/l10n/app_localizations.dart';

import '../mocks/shared_mocks.mocks.dart';

void main() {
  final fbMock = MockFirebaseProvider();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());

    GetIt.I.registerSingleton<FirebaseProvider>(fbMock);
    when(fbMock.userUid).thenReturn('DUMMY');
  });

  testWidgets('Name not entered', (WidgetTester tester) async {
    GetIt.I.get<SharedPreferencesProvider>().setUserName('');

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('QR code displayed', (WidgetTester tester) async {
    GetIt.I.get<SharedPreferencesProvider>().setUserName('DUMMY');

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    await tester.pumpAndSettle();

    expect(find.byType(PaddedQRCode), findsOneWidget);
  });
}

class MockApplication extends StatelessWidget {
  const MockApplication({required this.mockObserver, super.key});

  final MockNavigatorObserver mockObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: ShareAccountScreen(),
      ),
    );
  }
}
