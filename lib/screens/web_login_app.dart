import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WebLoginOnAppScreen extends StatelessWidget {
  static final String id = 'webLoginOnApp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('§Web'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              this._scanQRCode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: FaIcon(
                FontAwesomeIcons.desktop,
                size: 40,
              ),
              radius: 45,
            ),
            Card(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.windows),
                    title: Text('Last Active: '),
                    subtitle: Text('windows'),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.apple),
                    title: Text('Last Active: '),
                    subtitle: Text('apple'),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.linux),
                    title: Text('Last Active: '),
                    subtitle: Text('linux'),
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {},
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
      ),
    );
  }

  void _scanQRCode() async {
    var options = ScanOptions(
      restrictFormat: [BarcodeFormat.qr],
    );

    var scanResult = await BarcodeScanner.scan(options: options);

    print('scanned: ${scanResult.rawContent}');

    // ...
  }
}
