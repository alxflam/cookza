import 'package:cookza/components/app_icon_text.dart';
import 'package:cookza/components/version_text.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
import 'package:cookza/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MainAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: AppIconTextWidget(),
                ),
                // _getWebAppListTile(context),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.shareAccount),
                  leading: FaIcon(kShareAccountIcon),
                  onTap: () =>
                      Navigator.pushNamed(context, ShareAccountScreen.id),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.settings),
                  leading: FaIcon(kSettingsIcon),
                  onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: VersionText()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ListTile _getWebAppListTile(BuildContext context) {
  //   if (kIsWeb) {
  //     return ListTile(
  //         title: Text(AppLocalizations.of(context)!.logout),
  //         leading: Icon(Icons.power_settings_new),
  //         onTap: () async {
  //           // var util = sl.get<FirebaseProvider>();
  //           // await util.logOffFromWebClient(util.userUid);
  //         });
  //   }
  //   return ListTile(
  //     title: Text('$kAppName ${AppLocalizations.of(context)!.web}'),
  //     leading: FaIcon(kWebAppData),
  //     // onTap: () => Navigator.pushNamed(context, WebLoginOnAppScreen.id),
  //   );
  // }
}
