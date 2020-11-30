import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/screens/groups/meal_plan_group.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealPlanGroupsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamProvider<List<MealPlanCollectionEntity>>.value(
        value: sl.get<MealPlanManager>().collectionsAsStream,
        child: MealPlanGroupsTiles(),
      ),
    );
  }
}

class MealPlanGroupsTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groups = Provider.of<List<MealPlanCollectionEntity>>(context);
    var mealPlanManager = sl.get<MealPlanManager>();

    return Column(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  child: Text(AppLocalizations.of(context).createGroup),
                  onPressed: () async {
                    // await the creation or cancellation
                    var result = await this._createMealPlanGroup(context);
                    // if a new group got created
                    if (result != null) {
                      // then set the created group as the currently selected one
                      mealPlanManager.currentCollection = result.id;
                      // and make sure that the underlying view is updated
                      await Navigator.pushReplacementNamed(
                          context, MealPlanScreen.id);
                    }
                  })
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: groups == null ? 0 : groups.length,
            itemBuilder: (context, index) {
              var item = groups[index];
              var isActive = mealPlanManager.currentCollection == item.id;
              return ListTile(
                  title: Text(item.name),
                  leading: isActive ? Icon(Icons.check) : Text(''),
                  trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.pushNamed(context, MealPlanGroupScreen.id,
                          arguments: item);
                    },
                  ),
                  onTap: () {
                    mealPlanManager.currentCollection = item.id;
                    Navigator.pushReplacementNamed(context, MealPlanScreen.id);
                  });
            },
          ),
        ),
      ],
    );
  }

  Future<MealPlanCollectionEntity> _createMealPlanGroup(
      BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: '');

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text(AppLocalizations.of(context).createGroup),
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(context).groupName),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                              child: Icon(Icons.save),
                              color: Colors.green,
                              onPressed: () async {
                                var entity = await sl
                                    .get<MealPlanManager>()
                                    .createCollection(controller.text);
                                Navigator.pop(context, entity);
                              }),
                          RaisedButton(
                              child: Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
