import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ChangelogScreen extends StatelessWidget {
  static final String id = 'changelog';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Settings_Changelog)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangelogEntry(
                version: '0.0.1-alpha2',
                date: kDateFormatter.parse('20.07.2020'),
                changes: ['alpha2 Test']),
            ChangelogEntry(
                version: '0.0.1-alpha1',
                date: kDateFormatter.parse('19.07.2020'),
                changes: ['alpha1 Test']),
          ],
        ),
      ),
    );
  }
}

class ChangelogEntry extends StatelessWidget {
  final String version;
  final DateTime date;
  final List<String> changes;

  static final kTitleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  const ChangelogEntry({this.version, this.date, this.changes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                version,
                style: kTitleStyle,
              ),
              Spacer(),
              Text(
                kDateFormatter.format(date),
                style: kTitleStyle,
              ),
            ],
          ),
          Builder(builder: (context) {
            List<Widget> bulletPoints =
                this.changes.map((e) => toChangeBullet(e)).toList();

            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: bulletPoints,
              ),
            );
          })
        ],
      ),
    );
  }

  Widget toChangeBullet(String text) {
    return Text(kBulletCharacter + ' ' + text);
  }
}
