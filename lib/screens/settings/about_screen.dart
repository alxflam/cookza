import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/settings/ocr_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatelessWidget {
  static final String id = 'about';
  @override
  Widget build(BuildContext context) {
    final TextStyle subtitle = Theme.of(context).textTheme.subtitle1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          MaterialLocalizations.of(context)
              .aboutListTileTitle(translate(Keys.App_Title)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Icon(
                  kAppIconData,
                  size: 50,
                ),
              ),
            ),
            Text(
              translate(Keys.App_Title),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              'v2020-07-alpha',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Builder(builder: (context) {
              if (kIsWeb) {
                return Container();
              }
              return FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    var info = snapshot.data as PackageInfo;
                    return Text(
                      '${info.version} - Build ${info.buildNumber}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    );
                  }
                  return Container();
                },
              );
            }),
            Text(
              '© 2020 The Great Cookly Foundation',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        style: subtitle,
                        text:
                            'Cookly enables you to store, collect and share your favourite recipes in a data-privacy friendly manner.'),
                  ],
                ),
              ),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.map),
              title: Text('§Show Onboarding Intro'),
              onTap: () => Navigator.pushNamed(context, OnBoardingScreen.id),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.diceD20),
              title: Text('§Show Changelog'),
              onTap: () => kNotImplementedDialog(context),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.fileAlt),
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text('§Saved Images'),
              leading: FaIcon(FontAwesomeIcons.image),
              onTap: () {
                Navigator.pushNamed(context, SavedImagesScreen.id);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.camera),
              title: Text('§Test OCR'),
              onTap: () => Navigator.pushNamed(context, OCRTestScreen.id),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreenDivider extends StatelessWidget {
  const AboutScreenDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
      ),
    );
  }
}
