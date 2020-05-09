import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatelessWidget {
  static final String id = 'recipes';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${translatePlural(Keys.Ui_Recipe, Provider.of<AppProfile>(context).countRecipes)} (${Provider.of<AppProfile>(context).countRecipes})'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: FaIcon(Icons.list),
              ),
              Tab(
                icon: FaIcon(Icons.search),
              ),
            ],
          ),
        ),
        // todo make it tabs: first tab shows recipes, second tab allows to specify filter values => or set filter values in a new drawer?
        // sort and filter buttons on top, with a text stating how many recipes match the criteria
        body: TabBarView(
          children: [
            AllRecipesList(),
            FilterWidget(),
          ],
        ),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  List<Widget> _getTagSwitches(context) {
    return kTagMap.entries
        .map((tag) => SwitchListTile(
              title: Text(tag.key),
              secondary: FaIcon(tag.value),
              value: false,
              onChanged: (value) {},
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'keyword search'),
          ),
        ),
        Column(
          children: _getTagSwitches(context),
        ),
      ],
    );
  }
}

class AllRecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProfile>(
      builder: (context, appProfile, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          itemCount: appProfile.countRecipes,
          itemBuilder: (context, index) {
            var item = appProfile.recipes[index];
            return RecipeListTile(item: item);
          },
        );
      },
    );
  }
}
