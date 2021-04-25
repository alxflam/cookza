import 'package:cookza/constants.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: sl.get<ImageManager>().getRecipeImageFile(model.recipe),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  flex: 1,
                  child: Container(
                    height: 400,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                        image: FileImage(snapshot.data),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.grey.withAlpha(200),
                        child: CustomizedRatingBar(model),
                      ),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 100,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        Spacer(),
                        Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: CustomizedRatingBar(model)),
                      ],
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
      );
    });
  }
}

class CustomizedRatingBar extends StatelessWidget {
  final RecipeViewModel _model;

  CustomizedRatingBar(this._model);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // currently not supported by web
      return Container();
    }

    return FutureBuilder<int>(
      future: sl.get<RecipeManager>().getRating(_model.recipe),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _createRatingBar(0);
        }
        return _createRatingBar(snapshot.data);
      },
    );
  }

  RatingBar _createRatingBar(int? rating) {
    return RatingBar.builder(
      initialRating: rating?.toDouble() ?? 0,
      minRating: 0,
      maxRating: 5,
      direction: Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 20.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
      onRatingUpdate: (rating) {
        _model.setRating(rating.toInt());
      },
      updateOnDrag: false,
    );
  }
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
                  model.description ?? model.name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildDateRow(model),
            SizedBox(
              height: 20,
            ),
            _buildTagWidget(model),
          ],
        );
      },
    );
  }

  Row _buildDateRow(RecipeViewModel model) {
    var duration = Row(
      children: <Widget>[
        Icon(
          Icons.timer,
          size: 20,
        ),
        Text('${model.duration}min'),
      ],
    );

    var created = Row(
      children: <Widget>[
        Icon(
          Icons.add,
          size: 20,
        ),
        Text('${model.creationDate}'),
      ],
    );

    var modified = Row(
      children: <Widget>[
        Icon(
          Icons.edit,
          size: 20,
        ),
        Text('${model.modificationDate}'),
      ],
    );

    var widgets = [duration, created];

    if (model.modificationDate != model.creationDate) {
      widgets.add(modified);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  Widget _buildTagWidget(RecipeViewModel model) {
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
