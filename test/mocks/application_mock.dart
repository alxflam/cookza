import 'package:cookly/routes.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigator_observer_mock.dart';

class MockApplication extends StatelessWidget {
  const MockApplication({
    @required this.mockObserver,
  });

  final MockNavigatorObserver mockObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      routes: kRoutes,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: HomeScreen(),
      ),
    );
  }
}
