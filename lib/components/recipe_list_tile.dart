import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/util/entity_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecipeListTile extends StatelessWidget {
  final RecipeEntity item;
  final bool replaceRoute;

  const RecipeListTile(
      {required this.item, this.replaceRoute = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = ValueNotifier(item);

    return ValueListenableBuilder<RecipeEntity>(
      valueListenable: notifier,
      builder: (context, entity, child) {
        return ListTile(
          onTap: () async {
            if (replaceRoute) {
              await Navigator.pushReplacementNamed(context, RecipeScreen.id,
                  arguments: notifier.value);
            } else {
              final result = await Navigator.pushNamed(context, RecipeScreen.id,
                  arguments: notifier.value);
              if (result != null &&
                  result is RecipeEntity &&
                  changed(result, entity)) {
                notifier.value = result;
              }
            }
          },
          leading: Builder(
            builder: (context) {
              if (entity.image == null || entity.image == null) {
                return const ImagePlaceholder();
              }
              return FutureBuilder(
                future: sl.get<ImageManager>().getRecipeImageFile(entity),
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
                    return const ImagePlaceholder();
                  }
                },
              );
            },
          ),
          title: Text(entity.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.timer,
                    size: 15,
                  ),
                  Text('${entity.duration}min'),
                ],
              ),
              const VerticalDivider(),
              _buildTileIcons(entity),
            ],
          ),
          trailing: FutureBuilder<int>(
            future: sl.get<RecipeManager>().getRating(entity),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  width: 0,
                  height: 0,
                ); // no trailing widget
              }
              final rating = snapshot.data;
              return rating == null
                  ? const FaIcon(FontAwesomeIcons.circleQuestion)
                  : Icon(rating < 2
                      ? Icons.star_border
                      : rating < 4
                          ? Icons.star_half
                          : Icons.star);
            },
          ),
        );
      },
    );
  }

  Widget _buildTileIcons(RecipeEntity item) {
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
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

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 2 / 1,
      child: Icon(Icons.photo),
    );
  }
}
