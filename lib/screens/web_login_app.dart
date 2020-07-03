import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/firebase/general/firebase_handshake.dart';
import 'package:cookly/services/abstract/platform_info.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/mobile/qr_scanner.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WebLoginOnAppScreen extends StatelessWidget {
  static final String id = 'webLoginOnApp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${translate(Keys.App_Title)} ${translate(Keys.Ui_Web)}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var user = await sl.get<QRScanner>().scanUserQRCode();

              if (user != null) {
                sl.get<FirebaseProvider>().enableWebLoginFor(user.id);
              }
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
          Card(
            margin: EdgeInsets.all(0),
            child: Expanded(
              child: ListView.builder(
                itemCount: handshakes.length,
                itemBuilder: (context, index) {
                  var item = handshakes[index];
                  var date =
                      kDateFormatter.format(item.creationTimestamp.toDate());
                  return ListTile(
                    leading:
                        FaIcon(platformInfo.getOSIcon(item.operatingSystem)),
                    title: Text('$date'),
                    subtitle: Text(item.browser),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        sl
                            .get<FirebaseProvider>()
                            .logOffFromWebClient(item.requestor);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              sl.get<FirebaseProvider>().logOffAllWebClient();
            },
            color: Colors.orange,
            child: Row(
              children: [
                Icon(FontAwesomeIcons.signOutAlt),
                SizedBox(
                  width: 20,
                ),
                Text('Log off from all devices'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
