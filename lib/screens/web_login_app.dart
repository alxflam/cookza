import 'dart:convert';

import 'package:cookza/constants.dart';
import 'package:cookza/model/firebase/general/firebase_handshake.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/screens/collections/qr_scanner.dart';
import 'package:cookza/services/abstract/platform_info.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/web/web_login_manager.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WebLoginOnAppScreen extends StatelessWidget {
  static const String id = 'webLoginOnApp';

  const WebLoginOnAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$kAppName ${AppLocalizations.of(context).web}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final localizations = AppLocalizations.of(context);

              var json = await Navigator.pushNamed(context, QrScannerScreen.id);
              if (json == null || (json is! String)) {
                return;
              }

              try {
                var user = JsonUser.fromJson(jsonDecode(json));
                if (user.id.isNotEmpty) {
                  sl.get<FirebaseWebLoginManager>().enableWebLoginFor(user.id);
                }
              } on FormatException catch (e) {
                // ignore: unawaited_futures
                sl
                    .get<ExceptionHandler>()
                    .reportException(e, StackTrace.empty, DateTime.now());
                // show error to user
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(localizations.invalidQRCode),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent.withAlpha(40),
              radius: 45,
              child: const FaIcon(
                FontAwesomeIcons.desktop,
                size: 40,
              ),
            ),
            StreamProvider<List<FirebaseHandshake>>.value(
              initialData: const [],
              value: sl.get<FirebaseWebLoginManager>().webAppSessions(),
              child: const LogIns(),
            ),
          ],
        ),
      ),
    );
  }
}

class LogIns extends StatelessWidget {
  const LogIns({super.key});

  @override
  Widget build(BuildContext context) {
    var handshakes = Provider.of<List<FirebaseHandshake>>(context);
    var platformInfo = sl.get<PlatformInfo>();

    if (handshakes.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              var col = const Column(
                children: [],
              );
              for (var hs in handshakes) {
                var date = kDateFormatter.format(hs.creationTimestamp.toDate());

                col.children.add(Card(
                  child: ListTile(
                    leading: FaIcon(platformInfo.getOSIcon(hs.operatingSystem)),
                    title: Text(date),
                    subtitle: Text(hs.browser),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        sl
                            .get<FirebaseWebLoginManager>()
                            .logOffFromWebClient(hs.requestor);
                      },
                    ),
                  ),
                ));
              }
              return col;
            },
          ),
          ElevatedButton(
            style: kRaisedOrangeButtonStyle,
            onPressed: () {
              sl.get<FirebaseWebLoginManager>().logOffAllWebClient();
            },
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.rightFromBracket),
                const SizedBox(
                  width: 20,
                ),
                Text(AppLocalizations.of(context).logoutAllDevices),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
