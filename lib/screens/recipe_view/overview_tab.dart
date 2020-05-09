import 'package:cookly/constants.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/app_profile.dart';
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
            future: Provider.of<AppProfile>(context, listen: false)
                .getRecipeImage(model.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  flex: 1,
                  child: Container(
                    height: 400,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //       fit: BoxFit.fitWidth,
                    //       alignment: FractionalOffset.center,
                    //       image: snapshot.data),
                    // ),
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
      );
    });
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
                _buildRatingBar(model, context)
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

  Widget _buildRatingBar(RecipeViewModel model, BuildContext context) {
    if (kIsWeb) {
      // currently not supported by web
      return Container();
    }
    return RatingBar(
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
