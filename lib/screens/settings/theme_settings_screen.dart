import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  static const String id = 'theme';

  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).themeTitle),
      ),
      body: Consumer<ThemeModel>(
        builder: (context, model, widget) {
          return ListView.builder(
            itemCount: model.countThemes,
            itemBuilder: (context, index) {
              // TODO add system default theme entry
              var theme = model.getAvailableThemes()[index];
              return RadioListTile(
                title: Text(theme.displayName),
                value: theme.key,
                groupValue: model.getCurrentThemeKey(),
                onChanged: (value) {
                  model.theme = theme.key;
                },
              );
            },
          );
        },
      ),
    );
  }
}
