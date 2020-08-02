import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/settings/changelog_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:cookly/services/profile_deleter.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
              translate(Keys.Settings_Copyright),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        style: subtitle,
                        text: translate(Keys.Settings_Appdescription)),
                  ],
                ),
              ),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.map),
              title: Text(translate(Keys.Settings_Getstarted)),
              onTap: () => Navigator.pushNamed(context, OnBoardingScreen.id),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.diceD20),
              title: Text(translate(Keys.Settings_Changelog)),
              onTap: () => Navigator.pushNamed(context, ChangelogScreen.id),
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(translate(Keys.Settings_Localimages)),
              leading: FaIcon(FontAwesomeIcons.image),
              onTap: () {
                Navigator.pushNamed(context, SavedImagesScreen.id);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(translate(Keys.Settings_Support)),
              subtitle: Text('§Hilfe und Feedback '),
              leading: FaIcon(FontAwesomeIcons.questionCircle),
              onTap: () {
                launch("market://details?id=com.example.cookly");
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(translate(Keys.Settings_Deletealldata)),
              leading: FaIcon(FontAwesomeIcons.eraser),
              onTap: () {
                // open confirmation dialog
                showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(translate(Keys.Settings_Deletealldata)),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              translate(
                                Keys.Ui_Confirmdelete,
                                args: {"0": "§all data"},
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            translate(Keys.Ui_Cancel),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            translate(Keys.Ui_Delete),
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            // TODO: add progress indicator
                            // add exeception handler and show error
                            await sl.get<ProfileDeleter>().delete();
                            Navigator.pop(context);
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('§All data deleted')));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SettingSectionHeader('§Legal'),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.fileAlt),
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationVersion: '2020-08',
                  applicationIcon: Icon(kAppIconData),
                  applicationLegalese: '© 2020',
                );
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(translate(Keys.Settings_Privacystatement)),
              leading: FaIcon(FontAwesomeIcons.userSecret),
              onTap: () {
                kNotImplementedDialog(context);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(translate(Keys.Settings_Termsofuse)),
              leading: FaIcon(FontAwesomeIcons.envelopeOpenText),
              onTap: () {
                kNotImplementedDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreenDivider extends StatelessWidget {
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

class SettingSectionHeader extends StatelessWidget {
  final String _title;

  const SettingSectionHeader(this._title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _title,
        style: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
