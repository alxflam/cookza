import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/screens/groups/meal_plan_group.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

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
                  child: Text(translate(Keys.Ui_Creategroup)),
                  onPressed: () async {
                    this._createMealPlanGroup(context);
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

  Future<void> _createMealPlanGroup(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: '');

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text(translate(Keys.Ui_Creategroup)),
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
                                    hintText: translate(Keys.Ui_Groupname)),
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
                                sl
                                    .get<MealPlanManager>()
                                    .createCollection(controller.text);
                                Navigator.pop(context);
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
