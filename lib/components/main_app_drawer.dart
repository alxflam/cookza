import 'package:cookza/components/app_icon_text.dart';
import 'package:cookza/components/version_text.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
import 'package:cookza/screens/settings/export_settings_screen.dart';
import 'package:cookza/screens/settings/settings_screen.dart';
import 'package:cookza/screens/web_login_app.dart';
import 'package:cookza/services/abstract/recipe_file_import.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/web/web_login_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    final genericItems = [
      ListTile(
        title: Text(AppLocalizations.of(context).export),
        leading: const FaIcon(FontAwesomeIcons.fileExport),
        onTap: () => Navigator.pushNamed(context, ExportSettingsScreen.id),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).import),
        leading: const FaIcon(FontAwesomeIcons.fileImport),
        onTap: () {
          sl.get<RecipeFileImport>().parseAndImport(context);
        },
      ),
      _getWebAppListTile(context),
      ListTile(
        title: Text(AppLocalizations.of(context).settings),
        leading: const FaIcon(kSettingsIcon),
        onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
      ),
    ];

    items.add(
      const DrawerHeader(
        child: AppIconTextWidget(),
      ),
    );

    if (!kIsWeb) {
      items.add(ListTile(
        title: Text(AppLocalizations.of(context).shareAccount),
        leading: const FaIcon(kShareAccountIcon),
        onTap: () => Navigator.pushNamed(context, ShareAccountScreen.id),
      ));
    }

    items.addAll(genericItems);

    return Drawer(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: items,
            ),
          ),
          const Expanded(
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

  ListTile _getWebAppListTile(BuildContext context) {
    if (kIsWeb) {
      return ListTile(
        title: Text(AppLocalizations.of(context).logout),
        leading: const Icon(Icons.power_settings_new),
        onTap: () async {
          var util = sl.get<FirebaseWebLoginManager>();
          var user = sl.get<FirebaseProvider>().userUid;
          await util.logOffFromWebClient(user);
        },
      );
    }
    return ListTile(
      title: Text('$kAppName ${AppLocalizations.of(context).web}'),
      leading: const FaIcon(kWebAppData),
      onTap: () => Navigator.pushNamed(context, WebLoginOnAppScreen.id),
    );
  }
}
