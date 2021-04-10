import 'package:flutter_test/flutter_test.dart';

Future<void> inputFormField(
    WidgetTester tester, Finder finder, String value) async {
  await tester.enterText(finder, value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  expect(find.text(value), findsOneWidget);
}
