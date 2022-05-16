import 'package:cookza/viewmodel/settings/uom_visibility_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UoMVisibilityScreen extends StatelessWidget {
  static const String id = 'uomVisibility';

  const UoMVisibilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uomVisibilityModel = UoMVisibilitySettingsModel.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).unitLongPlural,
        ),
      ),
      body: ChangeNotifierProvider<UoMVisibilitySettingsModel>.value(
        value: uomVisibilityModel,
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
