import 'package:cookly/localization/keys.dart';
import 'package:cookly/viewmodel/settings/uom_visibility_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class UoMVisibilityScreen extends StatelessWidget {
  static final String id = 'uomVisibility';

  @override
  Widget build(BuildContext context) {
    var _model = UoMVisibilitySettingsModel.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Recipe_Unitlongplural),
        ),
      ),
      body: ChangeNotifierProvider<UoMVisibilitySettingsModel>.value(
        value: _model,
        child: Consumer<UoMVisibilitySettingsModel>(
          builder: (context, model, widget) {
            return ListView.builder(
              itemCount: model.countAll,
              itemBuilder: (context, index) {
                var uom = model.getByIndex(index);
                return SwitchListTile(
                  title: Text(uom.displayName),
                  value: model.isVisible(uom),
                  onChanged: (isActive) async {
                    model.setVisible(uom, isActive);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
