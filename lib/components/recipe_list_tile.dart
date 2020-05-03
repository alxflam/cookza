import 'package:cookly/constants.dart';
import 'package:cookly/model/recipe_view_model.dart';
import 'package:cookly/screens/recipe_screen.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecipeListTile extends StatelessWidget {
  final RecipeViewModel item;
  RecipeListTile({this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProfile>(builder: (context, appProfile, child) {
      return ListTile(
        onTap: () {
          Navigator.pushNamed(context, RecipeScreen.id, arguments: item.id);
        },
        leading: FutureBuilder(
          future: appProfile.getRecipeImage(item.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return AspectRatio(
                aspectRatio: 2 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                        image: snapshot.data),
                  ),
                ),
              );
            } else {
              return Container(
                child: Icon(Icons.photo),
              );
            }
          },
        ),
        title: Text(item.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  size: 15,
                ),
                Text('${item.duration}min'),
              ],
            ),
            VerticalDivider(),
            _buildTileIcons(item),
          ],
        ),
        trailing: item.rating == null
            ? FaIcon(FontAwesomeIcons.questionCircle)
            : Icon(item.rating < 2
                ? Icons.star_border
                : item.rating < 4 ? Icons.star_half : Icons.star),
      );
    });
  }

  _buildTileIcons(RecipeViewModel item) {
    // todo make a static map in the constants file for the static tags and their icon mapping
    List<IconData> icons = [];
    if (item.isVegan) {
      icons.add(kVeganIcon);
    }
    if (item.isVegetarian && !item.isVegan) {
      icons.add(kVegetarianIcon);
    }
    if (item.containsMeat) {
      icons.add(kMeatIcon);
    }
    if (item.containsFish) {
      icons.add(kFishIcon);
    }

    List<Widget> widgets = icons
        .map(
          (element) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FaIcon(
              element,
              size: 15,
            ),
          ),
        )
        .toList();

    return Row(
      children: widgets,
    );
  }
}
