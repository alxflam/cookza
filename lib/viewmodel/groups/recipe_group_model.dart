import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/groups/abstract_group_model.dart';

class RecipeGroupViewModel extends GroupViewModel {
  RecipeCollectionEntity _entity;

  String _name;

  RecipeGroupViewModel.of(RecipeCollectionEntity entity) {
    this._entity = entity;
    this._name = entity.name;
  }

  RecipeCollectionEntity get entity => this._entity;

  @override
  Future<void> rename(String value) async {
    await sl.get<RecipeManager>().renameCollection(value, this._entity);
    this._name = value;
    notifyListeners();
  }

  @override
  String get name {
    return _name;
  }

  @override
  Future<void> addUser(String userID, String name) async {
    await sl
        .get<RecipeManager>()
        .addUserToCollection(this.entity, userID, name);

    notifyListeners();
  }

  @override
  Future<void> leaveGroup() async {
    return sl.get<RecipeManager>().leaveRecipeGroup(this.entity);
  }

  @override
  Future<void> delete() {
    return sl.get<RecipeManager>().deleteCollection(this.entity);
  }
}