import 'package:cookza/viewmodel/settings/new_recipe_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewRecipeSettingsScreen extends StatelessWidget {
  static const String id = 'newRecipeSettings';

  const NewRecipeSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsModel = NewRecipeSettingsModel.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).functionsAddRecipe,
        ),
      ),
      body: ChangeNotifierProvider<NewRecipeSettingsModel>.value(
        value: settingsModel,
        child: SafeArea(
          child: Consumer<NewRecipeSettingsModel>(
              builder: (context, model, widget) {
            return ListView(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context).stdServings),
                  subtitle: Text(
                      '${model.defaultServingsSize} ${AppLocalizations.of(context).servings(model.defaultServingsSize)}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Slider(
                    value: model.defaultServingsSize.toDouble(),
                    max: 10,
                    min: 1,
                    label: AppLocalizations.of(context)
                        .servings(model.defaultServingsSize),
                    onChanged: (value) {
                      model.defaultServingsSize = value.toInt();
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
