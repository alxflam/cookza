import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

var navigatorService = NavigatorService();

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<NavigatorService>(navigatorService);
  });

  testWidgets('Label for Units of measure', (WidgetTester tester) async {
    await _initApp(tester, navigatorService.navigatorKey);

    var provider = StaticUnitOfMeasure();
    for (var uom in provider.getAll()) {
      var nameConsumer = uomDisplayTexts[uom.id];
      expect(nameConsumer, isNotNull);
      expect(
          nameConsumer!.call(navigatorService.currentContext!, 1), isNotEmpty);
    }
  });
}

Future<void> _initApp(
    WidgetTester tester, GlobalKey<NavigatorState> navKey) async {
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
    ],
    navigatorKey: navKey,
    home: Container(),
  ));
}
