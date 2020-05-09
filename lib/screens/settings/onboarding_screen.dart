import 'package:cookly/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  static final String id = 'onBoarding';

  void _onIntroEnd(context) {
    Navigator.pop(context);
  }

  Widget _buildImage(IconData icon) {
    return Align(
      child: Icon(
        icon,
        size: 200,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //  pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Cookly",
          body:
              "Cookly let's you manage all your favorite recipes in a single app.",
          image: _buildImage(kAppIconData),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create Recipes",
          body:
              "Create recipes manually or let cookly examine a picture or a webpage to retrieve a recipe.",
          image: _buildImage(kRecipesIconData),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Meal Planner",
          body: "Plan the meals for the whole week.",
          image: _buildImage(kMealPlannerIconData),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Shopping List",
          body: "Generate a shopping list for your planned meals",
          image: _buildImage(kShoppingListIconData),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Much more",
          body:
              "Further functionality include searching for similar recipes, filter recipes and sharing recipes with other cookly users",
          image: _buildImage(Icons.share),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Data privacy",
          body:
              "We believe apps shouldn't compromise data privacy by enforcing users to create or use social media accounts. You don\'t have to use an online account to be able to use cookly.",
          image: _buildImage(FontAwesomeIcons.userSecret),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
