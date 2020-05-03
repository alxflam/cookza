import 'dart:io';

import 'package:cookly/components/recipes_list.dart';
import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/recipe_edit_model.dart';
import 'package:cookly/model/recipe_edit_step.dart';
import 'package:cookly/model/recipe_view_model.dart';
import 'package:cookly/screens/recipe_screen.dart';
import 'package:cookly/screens/util/amount_text_formatter.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewRecipeScreen extends StatelessWidget {
  static final String id = 'newRecipeScreen';

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context).settings.arguments as RecipeEditModel;

    return Scaffold(
      appBar: AppBar(
        title: model.isCreate
            ? Text(translate(Keys.Recipe_Createrecipe))
            : Text(translate(Keys.Recipe_Editrecipe)),
      ),
      body: ChangeNotifierProvider(
        create: (context) => model,
        child: Column(
          children: <Widget>[
            NewRecipeStepper(),
          ],
        ),
      ),
    );
  }
}

class NewRecipeStepper extends StatelessWidget {
  nextButtonPressed(BuildContext context) async {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    if (model.currentStep + 1 < model.countSteps) {
      nextStep(context);
    } else {
      try {
        await model.save();
        Navigator.pushReplacementNamed(context, RecipeScreen.id,
            arguments: model.recipeId);
      } catch (e) {
        kErrorDialog(context, 'Error occured while saving', e.toString());
      }
    }
  }

  cancelButtonPressed(BuildContext context) {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    int modelStep = model.currentStep;
    if (modelStep >= 1) {
      previousStep(context);
    } else if (model.currentStep == 0) {
      Navigator.pop(context);
    }
  }

  nextStep(BuildContext context) {
    Provider.of<RecipeEditModel>(context, listen: false).nextStep();
  }

  previousStep(BuildContext context) {
    Provider.of<RecipeEditModel>(context, listen: false).previousStep();
  }

  List<Step> getSteps(BuildContext context) {
    return [
      getOverviewStep(context),
      getImageStep(context),
      getTagStep(context),
      getIngredientsStep(context),
      getInstructionsStep(context),
    ];
  }

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
            final descController =
                TextEditingController(text: model.description);

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

  Step getImageStep(BuildContext context) {
    return Step(
      title: Container(),
      isActive:
          Provider.of<RecipeEditModel>(context, listen: false).currentStep == 1,
      state: StepState.indexed,
      content: ChangeNotifierProvider.value(
        value:
            Provider.of<RecipeEditModel>(context, listen: false).imageStepModel,
        child: Consumer<RecipeImageEditStep>(
          builder: (context, model, child) {
            Future<void> getImage(ImageSource source) async {
              var image = await ImagePicker.pickImage(source: source);
              model.image = image;
            }

            return Column(
              children: <Widget>[
                Container(
                  child: model.image == null
                      ? SelectImageWidget(onSelect: getImage)
                      : ImageSelectedWidget(
                          image: model.image,
                          onDelete: () => model.image = null),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Step getTagStep(BuildContext context) {
    return Step(
      title: Container(),
      isActive:
          Provider.of<RecipeEditModel>(context, listen: false).currentStep == 2,
      state: StepState.indexed,
      content: ChangeNotifierProvider.value(
        value:
            Provider.of<RecipeEditModel>(context, listen: false).tagStepModel,
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

  Step getIngredientsStep(BuildContext context) {
    return Step(
      title: Container(),
      isActive:
          Provider.of<RecipeEditModel>(context, listen: false).currentStep == 3,
      state: StepState.indexed,
      content: ChangeNotifierProvider.value(
        value: Provider.of<RecipeEditModel>(context, listen: false)
            .ingredientStepModel,
        child: Consumer<RecipeIngredientEditStep>(
          builder: (context, model, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        '${model.servings} ${translate(Keys.Recipe_Servings)}'),
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      onPress: () => model.servings = model.servings - 1,
                    ),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      onPress: () => model.servings = model.servings + 1,
                    ),
                  ],
                ),
                FlatButton.icon(
                  onPressed: () {
                    model.addEmptyIngredient();
                  },
                  icon: Icon(Icons.add),
                  label: Text(translate(Keys.Ui_Addrow)),
                ),
                SingleChildScrollView(
                  child: DataTable(
                    horizontalMargin: 0,
                    columnSpacing: 25,
                    columns: [
                      DataColumn(
                        numeric: true,
                        label: Text(translate(Keys.Recipe_Amount)),
                      ),
                      DataColumn(
                        label: Text(translate(Keys.Recipe_Scale)),
                      ),
                      DataColumn(
                        label: Text(translate(Keys.Recipe_Ingredient)),
                      ),
                      DataColumn(
                        label: Text(' '),
                      ),
                    ],
                    rows: _getIngredientRows(context, model),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Step getInstructionsStep(BuildContext context) {
    return Step(
      title: Container(),
      isActive:
          Provider.of<RecipeEditModel>(context, listen: false).currentStep == 4,
      state: StepState.indexed,
      content: ChangeNotifierProvider.value(
        value: Provider.of<RecipeEditModel>(context, listen: false)
            .instructionStepModel,
        child: Consumer<RecipeInstructionEditStep>(
          builder: (context, model, child) {
            return Column(
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    model.addEmptyInstruction();
                  },
                  icon: Icon(Icons.add),
                  label: Text(translate(Keys.Ui_Addrow)),
                ),
                _getInstructionRows(context, model),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(context),
        currentStep: Provider.of<RecipeEditModel>(context).currentStep,
        onStepContinue: () {
          nextButtonPressed(context);
        },
        onStepTapped: (step) {
          kNotImplementedDialog(context);
        },
        onStepCancel: () {
          cancelButtonPressed(context);
        },
      ),
    );
  }

  List<DataRow> _getIngredientRows(
      BuildContext context, RecipeIngredientEditStep model) {
    // then iterate over ingredients so we have the index
    // for each index, we store the info for amount, scale and name
    // retrieve and update them by using the provider!

    List<DataRow> result = [];
    if (model.ingredients.length == 0) {
      return result;
    }

    for (var i = 0; i < model.ingredients.length; i++) {
      var amountController =
          TextEditingController(text: kFormatAmount(model.getAmountAt(i)));
      var ingredientController =
          TextEditingController(text: model.getIngredientAt(i).toString());

      amountController.addListener(
          () => model.setAmount(i, double.parse(amountController.text)));

      ingredientController
          .addListener(() => model.setIngredient(i, ingredientController.text));

      var row = DataRow(
        cells: [
          DataCell(
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
          ),
          DataCell(
            Builder(
              builder: (context) {
                List<DropdownMenuItem> items = sl
                    .get<UnitOfMeasureProvider>()
                    .getAll()
                    .map((uom) => DropdownMenuItem<String>(
                          child: Text(uom.getDisplayName(
                              double.parse(amountController.text).toInt())),
                          value: uom.id,
                        ))
                    .toList();
                return DropdownButton(
                  value: model.getScaleAt(i),
                  items: items,
                  onChanged: (value) {
                    model.setScale(i, value);
                  },
                );
              },
            ),
          ),
          DataCell(
            TextField(
              controller: ingredientController,
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: null,
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                model.removeIngredient(i);
              },
            ),
          ),
        ],
      );
      result.add(row);
    }

    return result;
  }

  Column _getInstructionRows(
      BuildContext context, RecipeInstructionEditStep model) {
    List<Widget> rows = [];
    if (model.instructions.length == 0) {
      return Column();
    }

    for (var i = 0; i < model.instructions.length; i++) {
      var textController =
          TextEditingController(text: model.getInstruction(i).toString());

      textController
          .addListener(() => model.setInstruction(textController.text, i));

      var row = Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              model.removeInstruction(i);
            },
          ),
          Expanded(
            child: TextFormField(
              minLines: 1,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: textController,
            ),
          ),
        ],
      );

      rows.add(row);
    }

    return Column(children: rows);
  }
}

class ImageSelectedWidget extends StatelessWidget {
  ImageSelectedWidget({@required this.image, @required this.onDelete});

  final File image;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: 300.0,
        ),
        padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: FlatButton(
                color: Colors.red.shade700,
                child: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  this.onDelete();
                },
              ),
            ),
          ],
        ));
  }
}

class SelectImageWidget extends StatelessWidget {
  final Function onSelect;

  SelectImageWidget({@required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(translate(Keys.Ui_Addimagelong)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                onSelect(ImageSource.gallery);
              },
            ),
            IconButton(
              onPressed: () {
                onSelect(ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
            )
          ],
        ),
      ],
    );
  }
}
