import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationParent extends StatelessWidget {
  final Widget _child;

  const LocalizationParent(this._child);

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale('en'),
      child: Builder(
        builder: (context) {
          return _child;
        },
      ),
    );
  }
}
