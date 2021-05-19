import 'package:cookza/components/app_icon_text.dart';
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
    return Center(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 100,
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 90,
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
      showSkipButton: false,
      dotsFlex: 2,
      nextFlex: 1,
      next: Icon(Icons.arrow_forward),
      done: showDoneButton
          ? Text(MaterialLocalizations.of(context).closeButtonLabel,
              style: TextStyle(fontWeight: FontWeight.w600))
          : Container(),
      dotsDecorator: DotsDecorator(
        size: Size(5.0, 5.0),
        activeColor: Theme.of(context).colorScheme.primary,
        activeSize: Size(20.0, 10.0),
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
        title: AppLocalizations.of(context).onboardingWelcomeTitle,
        body: AppLocalizations.of(context).onboardingWelcomeBody,
        image: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 100,
            child: Image(
              width: 100,
              image: AssetImage(kIconTransparent),
            ),
          ),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context).onboardingRecipeTitle,
        body: AppLocalizations.of(context).onboardingRecipeBody,
        image: _buildImage(kRecipesIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context).onboardingMealPlanTitle,
        body: AppLocalizations.of(context).onboardingMealPlanBody,
        image: _buildImage(kMealPlannerIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context).onboardingShoppingListTitle,
        body: AppLocalizations.of(context).onboardingShoppingListBody,
        image: _buildImage(kShoppingListIconData, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context).onboardingMoreTitle,
        body: AppLocalizations.of(context).onboardingMoreBody,
        image: _buildImage(Icons.share, context),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context).onboardingDataPrivacyTitle,
        body: AppLocalizations.of(context).onboardingDataPrivacyBody,
        image: _buildImage(FontAwesomeIcons.userShield, context),
        decoration: pageDecoration,
      ),
    ];

    if (!hasAcceptedAllTerms()) {
      sl
          .get<SharedPreferencesProvider>()
          .setAcceptedDataPrivacyStatement(false);
      sl.get<SharedPreferencesProvider>().setAcceptedTermsOfUse(false);

      basePages.add(
        _getAcceptTermsPage(context),
      );
    }

    return basePages;
  }

  bool hasAcceptedAllTerms() {
    return sl.get<SharedPreferencesProvider>().acceptedDataPrivacyStatement() &&
        sl.get<SharedPreferencesProvider>().acceptedTermsOfUse();
  }

  PageViewModel _getAcceptTermsPage(BuildContext context) {
    return PageViewModel(
      titleWidget: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
              child: AppIconTextWidget(
            alignment: MainAxisAlignment.center,
            size: 60,
          )),
        ),
      ),
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
                        Text(AppLocalizations.of(context).onboardingAcceptData),
                        Text(''),
                        Text(AppLocalizations.of(context)
                            .onboardingAcceptAuthentication),
                        TextCheckbox(
                            AppLocalizations.of(context).termsOfUse,
                            () => kNotImplementedDialog(context),
                            () => model.termsOfUse,
                            (bool value) => model.termsOfUse = value),
                        TextCheckbox(
                            AppLocalizations.of(context).privacyStatement,
                            () => kNotImplementedDialog(context),
                            () => model.privacyStatement,
                            (bool value) => model.privacyStatement = value),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: kRaisedGreenButtonStyle,
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
                                child:
                                    Text(AppLocalizations.of(context).accept),
                              ),
                            ),
                          ],
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
    );
  }
}

class TextCheckbox extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final Function getValue;
  final Function setValue;

  const TextCheckbox(this.title, this.onTap, this.getValue, this.setValue);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          trailing: Checkbox(
            activeColor: Colors.green,
            value: getValue(),
            onChanged: (value) => setState(() {
              setValue(value);
            }),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: AppLocalizations.of(context).readAndAccept,
                    style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: title,
                  style: TextStyle(color: Colors.blueAccent),
                  recognizer: TapGestureRecognizer()..onTap = this.onTap,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
