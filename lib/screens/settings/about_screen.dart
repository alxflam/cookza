import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/future_progress_dialog.dart';
import 'package:cookza/components/version_text.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/screens/settings/saved_images_screen.dart';
import 'package:cookza/services/profile_deleter.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const String id = 'about';

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context).textTheme.titleMedium;

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
              padding: const EdgeInsets.all(20),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 45,
                  child: const Image(
                    width: 45,
                    image: AssetImage(kIconTransparent),
                  ),
                ),
              ),
            ),
            const Text(
              kAppName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Builder(builder: (context) {
              if (kIsWeb) {
                return Container();
              }
              return const VersionText();
            }),
            Text(
              AppLocalizations.of(context).copyright,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
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
            const AboutScreenDivider(),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.map),
              title: Text(AppLocalizations.of(context).getStarted),
              onTap: () => Navigator.pushNamed(context, OnBoardingScreen.id),
            ),
            const AboutScreenDivider(),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.diceD20),
              title: Text(AppLocalizations.of(context).changelog),
              onTap: () => launchUrl(Uri.parse(kChangelogLink)),
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).localImages),
              leading: const FaIcon(FontAwesomeIcons.image),
              onTap: () {
                Navigator.pushNamed(context, SavedImagesScreen.id);
              },
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).support),
              subtitle: Text(AppLocalizations.of(context).supportSubtitle),
              leading: const FaIcon(FontAwesomeIcons.circleQuestion),
              onTap: () {
                launchUrl(Uri.parse(kPlayStoreLink));
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).sourceCode),
              leading: const FaIcon(FontAwesomeIcons.code),
              onTap: () {
                launchUrl(Uri.parse(kRepositoryLink));
              },
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).deleteAllData),
              leading: const FaIcon(FontAwesomeIcons.eraser),
              onTap: () async {
                // open confirmation dialog
                await showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return const DeleteAllDataDialog();
                  },
                );
              },
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).errorLog),
              leading: const FaIcon(FontAwesomeIcons.bug),
              onTap: () {
                Navigator.pushNamed(context, ErrorLogScreen.id);
              },
            ),
            SettingSectionHeader(AppLocalizations.of(context).legal),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.fileLines),
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: () async {
                final localizations = AppLocalizations.of(context);
                final platformInfo = await PackageInfo.fromPlatform();
                if (context.mounted) {
                  showLicensePage(
                    context: context,
                    applicationVersion: platformInfo.version,
                    applicationIcon: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 40),
                      child: const Image(
                        image: AssetImage(kIconTransparent),
                      ),
                    ),
                    applicationLegalese: localizations.copyright,
                  );
                }
              },
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).privacyStatement),
              leading: const FaIcon(FontAwesomeIcons.userSecret),
              onTap: () {
                kNotImplementedDialog(context);
              },
            ),
            const AboutScreenDivider(),
            ListTile(
              title: Text(AppLocalizations.of(context).termsOfUse),
              leading: const FaIcon(FontAwesomeIcons.envelopeOpenText),
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
  const DeleteAllDataDialog({Key? key}) : super(key: key);

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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
            ),
            ElevatedButton(
              style: kRaisedRedButtonStyle,
              onPressed: () async {
                try {
                  final localizations = AppLocalizations.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => SimpleDialog(
                            title: Center(
                                child: Text(AppLocalizations.of(context)
                                    .deleteAllData)),
                            children: [
                              FutureProgressDialog(
                                  sl.get<ProfileDeleter>().delete())
                            ],
                          ));

                  navigator.pop();
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text(localizations.deleteAllDataSuccess)));
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text(
                AppLocalizations.of(context).delete,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AboutScreenDivider extends StatelessWidget {
  const AboutScreenDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
      ),
    );
  }
}

class SettingSectionHeader extends StatelessWidget {
  final String _title;

  const SettingSectionHeader(this._title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
