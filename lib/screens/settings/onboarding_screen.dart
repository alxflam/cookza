import 'package:cookza/constants.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/onboarding_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatelessWidget {
  static final String id = 'onBoarding';

  void _onIntroEnd(context) {
    // proceed to app and don't show onboarding anymore
    sl.get<SharedPreferencesProvider>().setIntroductionShown(true);
    // the context can't be popped if the onboardign screen is shown on start of the app
    // directly navigate to the HomeScreen in this case
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }

  Widget _buildImage(IconData icon, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 40),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 100,
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showDoneButton = hasAcceptedAllTerms();
    return IntroductionScreen(
      pages: getPages(context),
      // in replay mode, show the done button
      // if user hasn't yet accepted terms, then hide it
      onDone: showDoneButton ? () => _onIntroEnd(context) : () {},
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(AppLocalizations.of(context).skip),
      next: Icon(Icons.arrow_forward),
      done: showDoneButton
          ? Text(MaterialLocalizations.of(context).closeButtonLabel,
              style: TextStyle(fontWeight: FontWeight.w600))
          : Container(),
      dotsDecorator: const DotsDecorator(
        size: Size(8.0, 8.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(15.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  List<PageViewModel> getPages(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //  pageColor: Colors.white,
      imagePadding: EdgeInsets.all(10),
    );

    var basePages = [
      PageViewModel(
        title: 'Welcome to Cookza',
        body:
            'Cookza let\'s you manage all your favorite recipes in a single app.',
        image: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 40),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 100,
                child: Image(
                  width: 100,
                  image: AssetImage(kIconTransparent),
                ),
              ),
            ),
          ),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'Organize your recipes',
        body:
            'Create recipes manually or let Cookza process a picture or a webpage to retrieve a recipe. Organize your recipes in groups and add friends to your recipe groups to share them',
        image: _buildImage(kRecipesIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'Meal Planner',
        body:
            'Plan the meals for the whole week and share your meal plan with your household members.',
        image: _buildImage(kMealPlannerIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'Shopping List',
        body: 'Generate a shopping list for your meal plan and share it',
        image: _buildImage(kShoppingListIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'Much more to explore',
        body:
            'You can also search for similar recipes, find recipes by ingredients and share recipes with other cookly users - by PDF, Text or by adding them to your recipe groups',
        image: _buildImage(Icons.share, context),
        decoration: pageDecoration,
      ),
    ];

    if (!hasAcceptedAllTerms()) {
      sl
          .get<SharedPreferencesProvider>()
          .setAcceptedDataPrivacyStatement(false);
      sl.get<SharedPreferencesProvider>().setAcceptedTermsOfUse(false);

      // TODO: create a viewmodel to encapsulate the calls to setValue only after the button has been pressed...
      basePages.add(
        PageViewModel(
          titleWidget: SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Data privacy and Terms of Use'))),
          bodyWidget: ChangeNotifierProvider<OnboardingModel>.value(
            value: OnboardingModel(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  child: Consumer<OnboardingModel>(
                    builder: (context, model, child) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                                'Cookly stores your recipes and meal plans on a cloud database provided by Google.'),
                            Text(
                                'Users are authenticated anonymously, therefore no Login credentials are required.'),
                            TextCheckbox(
                                'Terms of Use',
                                () => kNotImplementedDialog(context),
                                () => model.termsOfUse,
                                (bool value) => model.termsOfUse = value),
                            TextCheckbox(
                                'Data privacy statement',
                                () => kNotImplementedDialog(context),
                                () => model.privacyStatement,
                                (bool value) => model.privacyStatement = value),
                            ElevatedButton(
                              style: kRaisedGreenButtonStyle,
                              child: Text(MaterialLocalizations.of(context)
                                  .saveButtonLabel),
                              onPressed: model.acceptedAll
                                  ? () {
                                      sl
                                          .get<SharedPreferencesProvider>()
                                          .setAcceptedTermsOfUse(true);
                                      sl
                                          .get<SharedPreferencesProvider>()
                                          .setAcceptedDataPrivacyStatement(
                                              true);
                                      this._onIntroEnd(context);
                                    }
                                  : null,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return basePages;
  }

  bool hasAcceptedAllTerms() {
    return sl.get<SharedPreferencesProvider>().acceptedDataPrivacyStatement() &&
        sl.get<SharedPreferencesProvider>().acceptedTermsOfUse();
  }
}

class TextCheckbox extends StatelessWidget {
  final String title;
  final Function onTap;
  final Function getValue;
  final Function setValue;

  const TextCheckbox(this.title, this.onTap, this.getValue, this.setValue);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return CheckboxListTile(
        activeColor: Colors.green,
        value: getValue(),
        onChanged: (value) {
          setState(() {
            setValue(value);
          });
        },
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'I have read and accept the ',
                  style: TextStyle(color: Colors.white)),
              TextSpan(
                text: title,
                style: TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()..onTap = this.onTap,
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
      );
    });
  }
}
