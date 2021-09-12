import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  static const String id = 'theme';

  const ThemeSettingsScreen({Key? key}) : super(key: key);

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
