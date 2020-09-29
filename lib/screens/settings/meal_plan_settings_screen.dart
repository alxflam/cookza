import 'package:cookza/localization/keys.dart';
import 'package:cookza/viewmodel/settings/meal_plan_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class MealPlanSettingsScreen extends StatelessWidget {
  static final String id = 'mealPlanSettings';

  @override
  Widget build(BuildContext context) {
    var _model = MealPlanSettingsModel.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Mealplanner),
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
                  title: Text(translate(Keys.Settings_Weekdurationdesc)),
                ),
                RadioListTile(
                  title: Text(translate(Keys.Settings_Oneweek)),
                  value: 1,
                  groupValue: model.weeks,
                  onChanged: (isActive) async {
                    model.setWeeks(1);
                  },
                ),
                RadioListTile(
                  title: Text(translate(Keys.Settings_Twoweeks)),
                  value: 2,
                  groupValue: model.weeks,
                  onChanged: (isActive) async {
                    model.setWeeks(2);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(translate(Keys.Settings_Stdservingsdesc)),
                ),
                ListTile(
                  title: Text(translate(Keys.Settings_Stdservings)),
                  subtitle: Text(
                      '${model.standardServingsSize} ${translate(Keys.Recipe_Servings)}'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Slider(
                    value: model.standardServingsSize.toDouble(),
                    max: 10,
                    min: 1,
                    label: translate(Keys.Recipe_Servings),
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
