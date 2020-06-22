import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecipeListTile extends StatelessWidget {
  final RecipeEntity item;
  RecipeListTile({this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, RecipeScreen.id, arguments: item);
      },
      leading: Builder(
        builder: (context) {
          if (item.image == null || item.image.isEmpty) {
            return Container(
              child: Icon(Icons.photo),
            );
          }
          return FutureBuilder(
            future: sl.get<ImageManager>().getRecipeImageFile(item.id),
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
                        image: FileImage(snapshot.data),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  child: Icon(Icons.photo),
                );
              }
            },
          );
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
  }

  _buildTileIcons(RecipeEntity item) {
    // todo make a static map in the constants file for the static tags and their icon mapping
    List<IconData> icons = [];
    var isVegan = item.tags.contains(kVeganTag);
    var isVegetarian = item.tags.contains(kVegetarianTag);
    var containsMeat = item.tags.contains(kMeatTag);
    var containsFish = item.tags.contains(kFishTag);
    if (isVegan) {
      icons.add(kVeganIcon);
    }
    if (isVegetarian && !isVegan) {
      icons.add(kVegetarianIcon);
    }
    if (containsMeat) {
      icons.add(kMeatIcon);
    }
    if (containsFish) {
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
