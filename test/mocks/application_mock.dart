import 'package:cookza/routes.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'shared_mocks.mocks.dart';

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
      routes: kRoutes,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: const HomeScreen(),
      ),
    );
  }
}
