import 'dart:convert';

import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/web/responsive_widget.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/web/web_login_manager.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebLandingPage extends StatelessWidget {
  static const String id = 'landingPage';

  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 1000),
        child: const TopBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: const Column(
                      children: [
                        MainInfoBar(),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        FloatingBar(size: size),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Theme.of(context).bottomAppBarTheme.color,
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
  const MainInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Cookza',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          'Manage recipes the easy way',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.black),
        )
      ],
    );
  }
}

class FloatingBar extends StatelessWidget {
  final Size size;

  const FloatingBar({super.key, required this.size});

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
        elevation: 4,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  padding: const EdgeInsets.all(10),
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
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // top bar entries if any needed
          ],
        ),
      ),
    );
  }
}

Widget barcode(BuildContext context) {
  return FutureBuilder(
    future: sl.get<FirebaseWebLoginManager>().initializeWebLogin(
      (BuildContext context) {
        final log = Logger('WebLandingPage');
        log.info('navigating to home screen as it seems a login was granted');
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
      return const CircularProgressIndicator();
    },
  );
}
