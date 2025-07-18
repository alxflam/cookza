import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationParent extends StatelessWidget {
  final Widget _child;

  const LocalizationParent(this._child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: const Locale('en'),
      child: Builder(
        builder: (context) {
          return _child;
        },
      ),
    );
  }
}
