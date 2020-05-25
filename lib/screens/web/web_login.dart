import 'package:barcode_widget/barcode_widget.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WebLoginScreen extends StatelessWidget {
  static final String id = 'webLogin';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: width < 800
            ? _getSingleColumnContent(context)
            : _getDesktopLayoutContent(context));
  }

  _barcode(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Card(
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: '1234567890',
            width: 400,
            height: 400,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _barcodeInfo(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Scan the barcode with the app\n',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'See help for more info',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSingleColumnContent(BuildContext context) {
    return ListView(
      children: [
        _barcode(context),
        _barcodeInfo(context),
      ],
    );
  }

  _getDesktopLayoutContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '1. Open cookly on your mobile device',
                          textAlign: TextAlign.left,
                        ),
                        Text('2. Open the drawer and select web'),
                        Text('3. Scan the QR Code'),
                        RaisedButton(
                          child: Row(
                            children: [
                              Icon(Icons.warning),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Continue without device sync'),
                            ],
                          ),
                          color: Colors.orange,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _barcode(context),
                  _barcodeInfo(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
