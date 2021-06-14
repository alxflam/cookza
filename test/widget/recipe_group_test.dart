import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/model/entities/firebase/recipe_collection_entity.dart';
import 'package:cookza/model/firebase/collections/firebase_recipe_collection.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/groups/recipe_group.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mocks/shared_mocks.mocks.dart';
import '../utils/test_utils.dart';

final fb = MockFirebaseProvider();

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<FirebaseProvider>(fb);
    GetIt.I.registerSingleton<RecipeManager>(MockRecipeManager());

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Group screen shows members', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    RecipeCollectionEntityFirebase group = _createGroupModel();
    GetIt.I.get<SharedPreferencesProvider>().setUserName('Tux');
    await _initApp(tester, observer, group);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGroupScreen), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Tux'), findsOneWidget);
    expect(find.text('James Bond'), findsOneWidget);
  });

  testWidgets('Rename group', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    RecipeCollectionEntityFirebase group = _createGroupModel();

    await _initApp(tester, observer, group);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGroupScreen), findsOneWidget);
    expect(find.text('An awesome group'), findsOneWidget);

    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();

    await inputFormField(tester, find.byType(TextFormField), 'WoopWoop');
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
    expect(find.text('WoopWoop'), findsOneWidget);
  });

  testWidgets('Leave group', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    RecipeCollectionEntityFirebase group = _createGroupModel();

    await _initApp(tester, observer, group);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGroupScreen), findsOneWidget);
    expect(find.text('An awesome group'), findsOneWidget);

    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave Group'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialogTitle), findsOneWidget);

    await tester.tap(find.text('Leave Group').last);
    await tester.pumpAndSettle();
    verify(observer.didPush(any, any));

    expect(find.byType(RecipeGroupScreen), findsNothing);
    expect(find.byType(TestHomeScreen), findsOneWidget);
  });

  testWidgets('Add user', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    RecipeCollectionEntityFirebase group = _createGroupModel();

    await _initApp(tester, observer, group);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGroupScreen), findsOneWidget);
    expect(find.text('An awesome group'), findsOneWidget);

    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add User'));
    await tester.pump(Duration(seconds: 1));

    verify(observer.didPush(any, any));
  });

  testWidgets('Delete group', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    RecipeCollectionEntityFirebase group = _createGroupModel();

    await _initApp(tester, observer, group);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGroupScreen), findsOneWidget);
    expect(find.text('An awesome group'), findsOneWidget);

    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialogTitle), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    verify(observer.didPush(any, any));

    expect(find.byType(RecipeGroupScreen), findsNothing);
    expect(find.byType(TestHomeScreen), findsOneWidget);
  });
}

RecipeCollectionEntityFirebase _createGroupModel() {
  var now = Timestamp.now();
  var users = {'42': 'Tux', '007': 'James Bond'};
  var json = {
    'name': 'An awesome group',
    'creationTimestamp': now,
    'users': users,
  };

  when(fb.userUid).thenReturn('42');
  final group = RecipeCollectionEntityFirebase.of(
      FirebaseRecipeCollection.fromJson(json, '1234'));
  return group;
}

Future<void> _initApp(
    WidgetTester tester, NavigatorObserver observer, final Object args) async {
  await tester.pumpWidget(
    MaterialApp(
      routes: kRoutes,
      navigatorObservers: [observer],
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: Builder(
          builder: (context) => TestHomeScreen(args),
        ),
      ),
    ),
  );
}

class TestHomeScreen extends StatelessWidget {
  final Object args;

  const TestHomeScreen(this.args);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, RecipeGroupScreen.id, arguments: args);
        },
        child: Container(),
      ),
    );
  }
}
