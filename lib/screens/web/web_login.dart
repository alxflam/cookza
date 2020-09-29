import 'dart:convert';

import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return FutureBuilder(
      future: sl.get<FirebaseProvider>().initializeWebLogin(
        (BuildContext context) {
          print('navigating to home screen as it seems a login was granted');
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        },
        context,
      ),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          var json = JsonUser(
                  id: snapshot.data,
                  name: 'Cookly Web',
                  type: USER_TYPE.WEB_SESSION)
              .toJson();

          var data = jsonEncode(json);

          return PaddedQRCode(data, 400, 400);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _getSingleColumnContent(BuildContext context) {
    return ListView(
      children: [
        _barcodeExplanation(context),
        _barcode(context),
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
            _barcodeExplanation(context),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _barcode(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _barcodeExplanation(BuildContext context) {
    var tileColor = Provider.of<ThemeModel>(context).tileAccentColor;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 210,
                width: 210,
                child: Hero(
                  tag: 'appIcon',
                  child: CircleAvatar(
                    backgroundColor: tileColor,
                    child: Icon(
                      kAppIconData,
                      size: 100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Open Cookza on your mobile device',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '2. Open the drawer and select web',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '3. Scan the QR Code',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
