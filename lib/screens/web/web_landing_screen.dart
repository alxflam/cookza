import 'package:cookza/constants.dart';
import 'package:cookza/screens/web/web_login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const kGreyColor = Color.fromARGB(255, 51, 52, 55);

class WebLandingPage extends StatelessWidget {
  static final String id = 'landingPage';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: kGreyColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cookza Web App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),
                  ),
                  Text(
                    kAppVersion,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: addBackground(context),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                child: addWelcomeText(context),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: kGreyColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Impressum'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addBackground(BuildContext context) {
    return Hero(
      tag: 'appIcon',
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 180),
          child: Image(
            image: AssetImage(kIconTransparent),
          ),
        ),
      ),
    );
  }

  Widget addWelcomeText(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getConsentWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _getConsentWidget(BuildContext context) {
    return Builder(
      builder: (context) {
        var consent = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CheckboxListTile(
                  activeColor: Colors.green,
                  value: consent,
                  onChanged: (value) {
                    setState(() {
                      consent = value ?? false;
                    });
                  },
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!.readAndAccept,
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUse,
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              kNotImplementedDialog(context);
                            },
                        ),
                        TextSpan(
                            text: ' and ',
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                          text: AppLocalizations.of(context)!.privacyStatement,
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              kNotImplementedDialog(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                ElevatedButton(
                  style: kRaisedGreenButtonStyle,
                  onPressed: consent
                      ? () => Navigator.pushReplacementNamed(
                          context, WebLoginScreen.id)
                      : null,
                  child: Text(AppLocalizations.of(context)!.accept),
                )
              ],
            );
          },
        );
      },
    );
  }
}
