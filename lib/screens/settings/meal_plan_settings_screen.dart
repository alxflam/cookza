import 'package:cookza/viewmodel/settings/meal_plan_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MealPlanSettingsScreen extends StatelessWidget {
  static const String id = 'mealPlanSettings';

  @override
  Widget build(BuildContext context) {
    var _model = MealPlanSettingsModel.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).functionsMealPlanner,
        ),
      ),
      body: ChangeNotifierProvider<MealPlanSettingsModel>.value(
        value: _model,
        child: SafeArea(
          child: Consumer<MealPlanSettingsModel>(
              builder: (context, model, widget) {
            return ListView(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context).weekDurationDesc),
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).oneWeek),
                  value: 1,
                  groupValue: model.weeks,
                  onChanged: (isActive) async {
                    model.setWeeks(1);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).twoWeeks),
                  value: 2,
                  groupValue: model.weeks,
                  onChanged: (isActive) async {
                    model.setWeeks(2);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context).stdServingsDesc),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).stdServings),
                  subtitle: Text(
                      '${model.standardServingsSize} ${AppLocalizations.of(context).servings(model.standardServingsSize)}'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Slider(
                    value: model.standardServingsSize.toDouble(),
                    max: 10,
                    min: 1,
                    label: AppLocalizations.of(context)
                        .servings(model.standardServingsSize),
                    onChanged: (value) {
                      model.setStandardServingsSize(value.toInt());
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
