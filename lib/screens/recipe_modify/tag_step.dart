import 'package:cookza/constants.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Step getTagStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 2,
    state: StepState.indexed,
    content: const TagColumn(),
  );
}

class TagColumn extends StatelessWidget {
  const TagColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false).tagStepModel,
      child: Consumer<RecipeTagEditStep>(
        builder: (context, model, child) {
          return Column(
            children: <Widget>[
              SwitchListTile(
                secondary: const FaIcon(kVeganIcon),
                title: Text(AppLocalizations.of(context).tagsVegan),
                value: model.isVegan,
                onChanged: (value) {
                  model.setVegan(value);
                },
              ),
              SwitchListTile(
                secondary: const FaIcon(kVegetarianIcon),
                title: Text(AppLocalizations.of(context).tagsVegetarian),
                value: model.isVegetarian,
                onChanged: (value) {
                  model.setVegetarian(value);
                },
              ),
              SwitchListTile(
                secondary: const FaIcon(kMeatIcon),
                title: Text(AppLocalizations.of(context).tagsMeat),
                value: model.containsMeat,
                onChanged: (value) {
                  model.setContainsMeat(value);
                },
              ),
              SwitchListTile(
                secondary: const FaIcon(kFishIcon),
                title: Text(AppLocalizations.of(context).tagsFish),
                value: model.containsFish,
                onChanged: (value) {
                  model.setContainsFish(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
