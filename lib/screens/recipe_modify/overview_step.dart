import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/model/view/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

Step getOverviewStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 0,
    state: StepState.indexed,
    content: ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false)
          .overviewStepModel,
      child: Consumer<RecipeOverviewEditStep>(
        builder: (context, model, child) {
          final nameController = TextEditingController(text: model.name);
          final descController = TextEditingController(text: model.description);

          nameController.addListener(
            () {
              model.name = nameController.text;
            },
          );

          descController.addListener(
            () {
              model.description = descController.text;
            },
          );

          return Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: translate(Keys.Recipe_Recipename)),
                controller: nameController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: translate(Keys.Recipe_Recipedesc)),
                controller: descController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${translate(Keys.Recipe_Duration)}:'),
                  Flexible(
                    flex: 1,
                    child: Slider(
                      min: 1,
                      max: 120,
                      divisions: 24,
                      onChanged: (double value) {
                        model.duration = value?.toInt();
                      },
                      value: model.duration?.toDouble(),
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text("${model.duration} min"),
                  ),
                ],
              ),
              Wrap(
                spacing: 5,
                children: <Widget>[
                  FilterChip(
                    label: Text(translate(Keys.Recipe_Difficulty_Easy)),
                    onSelected: (value) {
                      model.difficulty = DIFFICULTY.EASY;
                    },
                    selected: model.difficulty == DIFFICULTY.EASY,
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  FilterChip(
                    label: Text(translate(Keys.Recipe_Difficulty_Medium)),
                    onSelected: (value) {
                      model.difficulty = DIFFICULTY.MEDIUM;
                    },
                    selected: model.difficulty == DIFFICULTY.MEDIUM,
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  FilterChip(
                    label: Text(translate(Keys.Recipe_Difficulty_Hard)),
                    onSelected: (value) {
                      model.difficulty = DIFFICULTY.HARD;
                    },
                    selected: model.difficulty == DIFFICULTY.HARD,
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    ),
  );
}
