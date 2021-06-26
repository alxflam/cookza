import 'package:cookza/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangelogScreen extends StatelessWidget {
  static final String id = 'changelog';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changelog),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangelogEntry(
              version: '0.0.23',
              date: kDateFormatter.parse('26.06.2021'),
              changes: [
                'Fix: Rezeptkachel wird nach Bearbeitung nicht sofort aktualisiert',
              ],
            ),
            ChangelogEntry(
              version: '0.0.22',
              date: kDateFormatter.parse('17.06.2021'),
              changes: [
                'Neu: Zutaten gruppieren in Zutatenliste',
                'Neu: Rezeptbild anzeigen (Tap auf Bild)',
                'Neu: Anpassungen für Android 11 (Splash Screen und Icon)',
                'Fix: Bei mehr als 10 bewerteten Rezepten wird die Favoriten Ansicht nicht mehr geladen',
                'Fix: Einträge in Einkaufsliste werden nicht korrekt sortiert',
                'Fixes: Kleinere Bugfixes und Verbesserungen',
                'Updates: Flutter 2.2, Google ML Kit statt Firebase ML'
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// displays a single exception
class ChangelogEntry extends StatelessWidget {
  final String version;
  final DateTime date;
  final List<String> changes;

  static final kTitleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  const ChangelogEntry(
      {required this.version, required this.date, required this.changes});

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
