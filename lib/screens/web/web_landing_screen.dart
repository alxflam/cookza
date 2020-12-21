import 'package:cookza/constants.dart';
import 'package:cookza/screens/web/web_login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WebLandingPage extends StatelessWidget {
  static final String id = 'landingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.grey.shade900],
        )),
        child: Padding(
          padding: EdgeInsets.all(50),
          child: SizedBox(
            height: 600,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                addBackground(context),
                addWelcomeText(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addBackground(BuildContext context) {
    var tileColor = Theme.of(context).primaryColor;

    return FractionallySizedBox(
        alignment: Alignment.centerRight, //to keep images aligned to right
        widthFactor: .4, //covers about 60% of the screen width
        child: Hero(
          tag: 'appIcon',
          child: CircleAvatar(
            backgroundColor: tileColor,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 400),
              child: Image(
                image: AssetImage(kIconTransparent),
              ),
            ),
          ),
        ));
  }

  Widget addWelcomeText(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft, //text aligned to left side
      widthFactor: .6, //covers about half of the screen
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Cookza',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            Text(
              kAppVersion,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
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
                      consent = value;
                    });
                  },
                  title: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'I have read the ',
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(color: Colors.blueAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          kNotImplementedDialog(context);
                        },
                    ),
                    TextSpan(
                        text: ' and ', style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: 'Data Privacy Statement ',
                      style: TextStyle(color: Colors.blueAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          kNotImplementedDialog(context);
                        },
                    ),
                    TextSpan(
                        text: 'and accept these conditions',
                        style: TextStyle(color: Colors.white)),
                  ])),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                ElevatedButton(
                  style: kRaisedGreenButtonStyle,
                  child: Text('§Proceed'),
                  onPressed: consent
                      ? () => Navigator.pushReplacementNamed(
                          context, WebLoginScreen.id)
                      : null,
                )
              ],
            );
          },
        );
      },
    );
  }
}
