import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/future_progress_dialog.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/screens/settings/changelog_screen.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/screens/settings/saved_images_screen.dart';
import 'package:cookza/services/profile_deleter.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          MaterialLocalizations.of(context).aboutListTileTitle(kAppName),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Image(
                    width: 45,
                    image: AssetImage(kIconTransparent),
                  ),
                  radius: 45,
                ),
              ),
            ),
            Text(
              kAppName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              kAppVersion,
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
              AppLocalizations.of(context).copyright,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        style: subtitle,
                        text: AppLocalizations.of(context).appDescription),
                  ],
                ),
              ),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.map),
              title: Text(AppLocalizations.of(context).getStarted),
              onTap: () => Navigator.pushNamed(context, OnBoardingScreen.id),
            ),
            AboutScreenDivider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.diceD20),
              title: Text(AppLocalizations.of(context).changelog),
              onTap: () => Navigator.pushNamed(context, ChangelogScreen.id),
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).localImages),
              leading: FaIcon(FontAwesomeIcons.image),
              onTap: () {
                Navigator.pushNamed(context, SavedImagesScreen.id);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).support),
              subtitle: Text(AppLocalizations.of(context).supportSubtitle),
              leading: FaIcon(FontAwesomeIcons.questionCircle),
              onTap: () {
                launch(kPlayStoreLink);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).deleteAllData),
              leading: FaIcon(FontAwesomeIcons.eraser),
              onTap: () async {
                // open confirmation dialog
                await showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return DeleteAllDataDialog();
                  },
                );
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).errorLog),
              leading: FaIcon(FontAwesomeIcons.bug),
              onTap: () {
                Navigator.pushNamed(context, ErrorLogScreen.id);
              },
            ),
            SettingSectionHeader(AppLocalizations.of(context).legal),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.fileAlt),
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationVersion: kAppVersion,
                  applicationIcon: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 40),
                    child: Image(
                      image: AssetImage(kIconTransparent),
                    ),
                  ),
                  applicationLegalese: '© 2020',
                );
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).privacyStatement),
              leading: FaIcon(FontAwesomeIcons.userSecret),
              onTap: () {
                kNotImplementedDialog(context);
              },
            ),
            AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).termsOfUse),
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

class DeleteAllDataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: AlertDialogTitle(
              title: AppLocalizations.of(context).deleteAllData),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).confirmDeleteAll),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: kRaisedGreyButtonStyle,
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: kRaisedRedButtonStyle,
              child: Text(
                AppLocalizations.of(context).delete,
              ),
              onPressed: () async {
                try {
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: SimpleDialog(
                        title: Center(
                            child: Text(
                                AppLocalizations.of(context).deleteAllData)),
                        children: [
                          FutureProgressDialog(
                              sl.get<ProfileDeleter>().delete())
                        ],
                      ));

                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          AppLocalizations.of(context).deleteAllDataSuccess)));
                } catch (e) {
                  Navigator.pop(context);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        );
      },
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

  SettingSectionHeader(this._title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        _title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
