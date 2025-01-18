import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/api/chefkoch.dart';
import 'package:cookza/services/api/home_connect.dart';
import 'package:cookza/services/flutter/service_locator.dart';

abstract class RecipeIntentImporter {
  bool canHandle(String intentData);

  Future<RecipeEntity> getRecipe(String intentData);
}

class ImporterRegistry {
  final _importers = <RecipeIntentImporter>[];

  ImporterRegistry() {
    var ck = sl.get<ChefkochImporter>();
    _importers.add(ck);
    var hc = sl.get<HomeConnectImporter>();
    _importers.add(hc);
  }

  List<RecipeIntentImporter> getImporters() => this._importers;
}
