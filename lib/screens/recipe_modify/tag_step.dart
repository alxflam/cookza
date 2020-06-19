import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Step getTagStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 2,
    state: StepState.indexed,
    content: ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false).tagStepModel,
      child: Consumer<RecipeTagEditStep>(
        builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SwitchListTile(
                    secondary: FaIcon(kVeganIcon),
                    title: Text(translate(Keys.Recipe_Tags_Vegan)),
                    value: model.isVegan,
                    onChanged: (value) {
                      model.setVegan(value);
                    },
                  ),
                  SwitchListTile(
                    secondary: FaIcon(kVegetarianIcon),
                    title: Text(translate(Keys.Recipe_Tags_Vegetarian)),
                    value: model.isVegetarian,
                    onChanged: (value) {
                      model.setVegetarian(value);
                    },
                  ),
                  SwitchListTile(
                    secondary: FaIcon(kMeatIcon),
                    title: Text(translate(Keys.Recipe_Tags_Meat)),
                    value: model.containsMeat,
                    onChanged: (value) {
                      model.setContainsMeat(value);
                    },
                  ),
                  SwitchListTile(
                    secondary: FaIcon(kFishIcon),
                    title: Text(translate(Keys.Recipe_Tags_Fish)),
                    value: model.containsFish,
                    onChanged: (value) {
                      model.setContainsFish(value);
                    },
                  ),
                  _buildTagWidget(context),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}

_buildTagWidget(BuildContext context) {
  List<Widget> chips = kTagMap.entries
      .skip(4)
      .map(
        (tag) => InputChip(
          avatar: FaIcon(
            tag.value,
            size: 15,
          ),
          onPressed: () {
            kNotImplementedDialog(context);
          },
          label: Text(tag.key),
        ),
      )
      .toList();

  return Wrap(
    spacing: 10,
    children: chips,
  );
}
