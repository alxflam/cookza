import 'dart:convert';

import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/web/responsive_widget.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/web/web_login_manager.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebLandingPage extends StatelessWidget {
  static const String id = 'landingPage';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 1000),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: SizedBox(
                    height: size.height * 0.4,
                    width: size.width,
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Column(
                        children: [
                          MainInfoBar(),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          FloatingBar(size: size),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            BottomBar(),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Theme.of(context).bottomAppBarColor,
      child: ResponsiveWidget.isSmallScreen(context)
          ? Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Impressum',
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Impressum',
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class MainInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Cookza',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          'Manage recipes the easy way',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.black),
        )
      ],
    );
  }
}

class FloatingBar extends StatelessWidget {
  final Size size;

  const FloatingBar({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.3,
            left: 30,
            right: 30,
          ),
          child: Column(
            children: [
              _buildFloatingElement(context),
            ],
          )),
    );
  }

  Padding _buildFloatingElement(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.height / 80),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 4,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      InstructionText('1. Open Cookza on your phone'),
                      InstructionText(
                        '2. Select Cookza Web',
                      ),
                      InstructionText(
                        "3. Press the '+' Icon",
                      ),
                      InstructionText(
                        '4. Scan the QR Code to the right',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      barcode(context),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // top bar entries if any needed
            ],
          ),
        ),
      ),
    );
  }
}

Widget barcode(BuildContext context) {
  return FutureBuilder(
    future: sl.get<FirebaseWebLoginManager>().initializeWebLogin(
      (BuildContext context) {
        print('navigating to home screen as it seems a login was granted');
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      },
      context,
    ),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        var json = JsonUser(
                id: snapshot.data!,
                name: 'Cookly Web',
                type: USER_TYPE.WEB_SESSION)
            .toJson();

        var data = jsonEncode(json);

        return PaddedQRCode(data, 300, 300);
      }
      return CircularProgressIndicator();
    },
  );
}
