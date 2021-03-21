import 'package:cookza/constants.dart';
import 'package:cookza/model/firebase/general/firebase_handshake.dart';
import 'package:cookza/services/abstract/platform_info.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WebLoginOnAppScreen extends StatelessWidget {
  static final String id = 'webLoginOnApp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$kAppName ${AppLocalizations.of(context)!.web}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // TODO: reenable web login
              // var user = await sl.get<QRScanner>().scanUserQRCode();

              // if (user != null) {
              //   sl.get<FirebaseProvider>().enableWebLoginFor(user.id);
              // }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent.withAlpha(40),
              child: FaIcon(
                FontAwesomeIcons.desktop,
                size: 40,
              ),
              radius: 45,
            ),
            StreamProvider<List<FirebaseHandshake>>.value(
              initialData: [],
              value: sl.get<FirebaseProvider>().webAppSessions(),
              child: LogIns(),
            ),
          ],
        ),
      ),
    );
  }
}

class LogIns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var handshakes = Provider.of<List<FirebaseHandshake>>(context);
    var platformInfo = sl.get<PlatformInfo>();

    if (handshakes == null || handshakes.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              var col = Column(
                children: [],
              );
              for (var hs in handshakes) {
                var date = kDateFormatter.format(hs.creationTimestamp.toDate());

                col.children.add(Card(
                  child: ListTile(
                    leading: FaIcon(platformInfo.getOSIcon(hs.operatingSystem)),
                    title: Text('$date'),
                    subtitle: Text(hs.browser),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        sl
                            .get<FirebaseProvider>()
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
              sl.get<FirebaseProvider>().logOffAllWebClient();
            },
            child: Row(
              children: [
                Icon(FontAwesomeIcons.signOutAlt),
                SizedBox(
                  width: 20,
                ),
                Text(AppLocalizations.of(context)!.logoutAllDevices),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
