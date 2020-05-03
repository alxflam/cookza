import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/recipe_edit_model.dart';
import 'package:cookly/model/recipe_view_model.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/new_recipe_screen.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const SHARE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Share, Icons.share);
  static const EDIT =
      const PopupMenuButtonChoices._internal(Keys.Ui_Edit, Icons.edit);
  static const DELETE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Delete, Icons.delete);
}

class RecipeScreen extends StatelessWidget {
  static final String id = 'recipeScreen';

  @override
  Widget build(BuildContext context) {
    final String recipeId = ModalRoute.of(context).settings.arguments as String;

    RecipeViewModel baseModel =
        Provider.of<AppProfile>(context, listen: false).getRecipeById(recipeId);

    return ChangeNotifierProvider<RecipeViewModel>(
      create: (BuildContext context) {
        return baseModel;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(baseModel.name != null ? baseModel.name : ''),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.SHARE.icon),
                      value: PopupMenuButtonChoices.SHARE,
                    ),
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.EDIT.icon),
                      value: PopupMenuButtonChoices.EDIT,
                    ),
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.DELETE.icon),
                      value: PopupMenuButtonChoices.DELETE,
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case PopupMenuButtonChoices.SHARE:
                      kNotImplementedDialog(context);
                      break;
                    case PopupMenuButtonChoices.EDIT:
                      Navigator.pushNamed(context, NewRecipeScreen.id,
                          arguments: RecipeEditModel.modify(baseModel.recipe));
                      break;
                    case PopupMenuButtonChoices.DELETE:
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(translate(Keys.Ui_Delete)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(translate(Keys.Ui_Confirmdelete,
                                      args: {"0": baseModel.name})),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  translate(Keys.Ui_Cancel),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  translate(Keys.Ui_Delete),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  Provider.of<AppProfile>(context,
                                          listen: false)
                                      .deleteRecipe(baseModel.id);
                                  Navigator.pushNamed(context, HomeScreen.id);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      break;
                    default:
                  }
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: FaIcon(kInfoIconData),
                ),
                Tab(
                  icon: FaIcon(kIngredientsIconData),
                ),
                Tab(
                  icon: FaIcon(kRecipesIconData),
                ),
                Tab(
                  icon: FaIcon(kSimilarRecipesIconData),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: Provider.of<AppProfile>(context, listen: false)
                        .getRecipeImage(baseModel.id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: snapshot.data),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Icon(Icons.image),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: SubImageRow(),
                  ),
                ],
              ),
              ListView(
                children: <Widget>[
                  ListOfIngredients(),
                ],
              ),
              ListView(
                children: <Widget>[
                  CookingInstructions(),
                ],
              ),
              SimilarRecipesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class SimilarRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return FutureBuilder(
          future: sl.get<SimilarityService>().getSimilarRecipes(model.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text('No similar recipes found'),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return RecipeListTile(item: snapshot.data[index]);
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}

Widget _buildStep({int num, String content}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.grey,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Text(num.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
          ),
        ),
      ),
      SizedBox(
        width: 16.0,
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(content),
        ),
      )
    ],
  );
}

class SubImageRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Wrap(
              children: <Widget>[
                Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  model.description == null ? model.name : model.description,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      size: 20,
                    ),
                    Text('${model.duration}min'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                    ),
                    Text('${model.creationDate}'),
                  ],
                ),
                RatingBar(
                  initialRating: model.rating.toDouble(),
                  itemSize: 20,
                  maxRating: 5,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    );
                  },
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  onRatingUpdate: (rating) {
                    Provider.of<RecipeViewModel>(context, listen: false)
                        .setRating(rating.toInt());
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildTagWidget(model),
          ],
        );
      },
    );
  }

  _buildTagWidget(RecipeViewModel model) {
    List<Widget> chips = model.tags
        .map(
          (tag) => Chip(
            avatar: FaIcon(
              kTagMap[tag],
              size: 15,
            ),
            label: Text(tag),
          ),
        )
        .toList();

    return Wrap(
      spacing: 10,
      children: chips,
    );
  }
}

class CookingInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Builder(
            builder: (context) {
              List<Row> instructions = [];

              for (var i = 0; i < model.instructions.length; i++) {
                instructions.add(
                    _buildStep(content: model.instructions[i], num: i + 1));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: instructions,
              );
            },
          ),
        );
      },
    );
  }
}

class ListOfIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Container(
          child: Column(
            children: <Widget>[
              ListOfIngredientsHeader(),
              DataTable(
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
                ],
                rows: _buildIngredientRows(context, model),
              )
            ],
          ),
        );
      },
    );
  }

  List<DataRow> _buildIngredientRows(
      BuildContext context, RecipeViewModel model) {
    return model.ingredients
        .map(
          (item) => DataRow(
            cells: [
              DataCell(
                Text(kFormatAmount(item.amount)),
              ),
              DataCell(
                Text(item.unitOfMeasure),
              ),
              DataCell(
                Text(item.ingredient.name),
              ),
            ],
          ),
        )
        .toList();
  }
}

class ListOfIngredientsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int servings = 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RoundIconButton(
          icon: FontAwesomeIcons.minus,
        ),
        Text(translate(Keys.Recipe_Ingredientsforservings,
            args: {"0": servings})),
        RoundIconButton(
          icon: FontAwesomeIcons.plus,
        ),
      ],
    );
  }
}
