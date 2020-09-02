import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookly/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/services/ingredients_calculator.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/shopping_list_items_generator.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShoppingListModel extends ChangeNotifier {
  MutableShoppingList _listEntity;

  static int _shoppingListDays =
      sl.get<SharedPreferencesProvider>().getMealPlanWeeks() * 7;

  DateTime _lastDate;
  DateTime _firstDate;

  List<IngredientNote> _requiredIngredients = [];
  List<IngredientNote> _availableIngredients = [];
  Map<String, int> _recipeReferences = {};
  List<MutableShoppingListItem> _items = [];
  bool _initalized = false;

  ShoppingListModel.from(ShoppingListEntity listEntity) {
    this._listEntity = MutableShoppingList.of(listEntity);
    _firstDate = DateTime.now();
    _lastDate = _firstDate.add(Duration(days: _shoppingListDays));
  }

  ShoppingListModel.empty({String groupID})
      : this._firstDate = DateTime.now(),
        this._lastDate = DateTime.now().add(Duration(days: _shoppingListDays)) {
    _listEntity =
        MutableShoppingList.newList(groupID, DateTime.now(), initialEndDate);
  }

  bool get initialized => this._initalized;

  Future<List<ShoppingListItemModel>> getItems() async {
    // lazy initialize on first get call
    if (_items.isNotEmpty) {
      // create the viewmodels
      var viewModels =
          this._items.map((e) => ShoppingListItemModel.ofEntity(e)).toList();

      _registerListeners(viewModels);

      // then return them
      return viewModels;
    }

    // add custom items
    for (var item in this._listEntity.items.where((e) => e.isCustom)) {
      this._items.add(MutableShoppingListItem.ofEntity(item));
    }

    List<MutableShoppingListItem> generatedItems = [];
    try {
      generatedItems = await sl
          .get<ShoppingListItemsGenerator>()
          .generateItems(this._listEntity);
    } on PlatformException catch (e) {
      // may happen if the shopping list contains a recipe from a group the current user  does not have read access to
      var context = sl.get<NavigatorService>().currentContext;
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('§No access to a recipe from the shopping list')));
    }

    // processed generated already bought items
    for (var item
        in this._listEntity.items.where((e) => !e.isCustom && e.isBought)) {
      var generatedItem = generatedItems.firstWhere(
          (e) =>
              e.ingredientNote.amount == item.ingredientNote.amount &&
              e.ingredientNote.ingredient.name ==
                  item.ingredientNote.ingredient.name &&
              e.ingredientNote.unitOfMeasure ==
                  item.ingredientNote.unitOfMeasure,
          orElse: () => null);
      if (generatedItem != null) {
        generatedItems.remove(generatedItem);
        this._items.add(MutableShoppingListItem.ofEntity(item));
      } else {
        this._listEntity.removeItem(item);
      }
    }

    this._items.addAll(generatedItems);

    this._sortItems();

    var result =
        this._items.map((e) => ShoppingListItemModel.ofEntity(e)).toList();

    _registerListeners(result);

    this._initalized = true;

    return result;
  }

  void _sortItems() {
    this._items.sort((a, b) {
      if (a.isBought && !b.isBought) {
        return 1;
      }
      if (b.isBought && !a.isBought) {
        return -1;
      }
      return 0;
    });
    notifyListeners();
  }

  String get shortTitle {
    return this._listEntity.dateFrom.day.toString() +
        '.' +
        this._listEntity.dateFrom.month.toString() +
        ' - ' +
        this._listEntity.dateUntil.day.toString() +
        '.' +
        this._listEntity.dateUntil.month.toString();
  }

  DateTime get dateFrom => _listEntity.dateFrom;

  DateTime get dateEnd => _listEntity.dateUntil;

  DateTime get lastDate => _lastDate;

  DateTime get initialEndDate {
    // initial range is always till next sunday
    var startDate = DateTime.now();
    int weekday = startDate.weekday;
    int days = weekday < 7 ? 7 - weekday : 7;
    return startDate.add(Duration(days: days));
  }

  set dateFrom(DateTime value) => _listEntity.dateFrom = value;

  set dateEnd(DateTime value) => _listEntity.dateUntil = value;

  String get groupID => this._listEntity.groupID;

  set groupID(String value) {
    this._listEntity.groupID = value;
  }

  void reorder(int newIndex, int oldIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    var item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  void addCustomItem(IngredientNoteEntity ingredientNote) {
    // create list entity
    var entity =
        MutableShoppingListItem.ofIngredientNote(ingredientNote, false, true);
    // add to entity
    this._listEntity.addItem(entity);
    // add to transient items list
    this._items.add(entity);
    // save changes
    this._save();
    // update the view
    notifyListeners();
  }

  void _save() {
    // only save custom items
    var customItems =
        this._items.where((a) => a.isCustom || a.isBought).toList();
    // remove all entities
    this._listEntity.clearItems();

    // add valid items
    for (var item in customItems) {
      // add to entity
      this._listEntity.addItem(item);
    }

    // then save the changes - creates the list if it does not yet exist
    sl.get<ShoppingListManager>().createOrUpdate(this._listEntity);
  }

  void itemGotEdited(ShoppingListItemModel changedEntity) {
    this._save();
    this._sortItems();
    notifyListeners();
  }

  bool _dateIsMatching(MealPlanDateEntry item) {
    return item.date
            .isBefore(this._listEntity.dateUntil.add(Duration(days: 1))) &&
        item.date
            .isAfter(this._listEntity.dateFrom.subtract(Duration(days: 1)));
  }

  void removeItem(int index, ShoppingListItemModel itemModel) {
    // remove the item from the view list
    this._items.removeAt(index);
    // set to deleted
    itemModel.noLongerNeeded = true;
    // then remove the no longer needed items
    this._listEntity.removeBought();
    // then save changes
    this._save();
  }

  void _registerListeners(List<ShoppingListItemModel> viewModels) {
    // register a listener to each of the viewmodels
    viewModels.forEach((e) {
      e.addListener(() {
        this.itemGotEdited(e);
      });
    });
  }
}

class ShoppingListItemModel extends ChangeNotifier {
  UnitOfMeasure _uom;
  MutableShoppingListItem _entity;

  ShoppingListItemModel.ofEntity(ShoppingListItemEntity entity) {
    this._entity = entity;
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    var uom =
        uomProvider.getUnitOfMeasureById(entity.ingredientNote.unitOfMeasure);
    this._uom = uom;
  }

  ShoppingListItemModel.customItemOfIngredient(IngredientNoteEntity entity) {
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    var uom = uomProvider.getUnitOfMeasureById(entity.unitOfMeasure);
    this._uom = uom;
  }

  ShoppingListItemModel.customItemOfEntity(ShoppingListItemEntity entity) {
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    var uom =
        uomProvider.getUnitOfMeasureById(entity.ingredientNote.unitOfMeasure);
    this._uom = uom;
  }

  String get uom {
    // TODO: there should be a null uom!
    if (_uom == null) {
      return '';
    }
    return _uom.getDisplayName(this._entity.ingredientNote.amount.toInt());
  }

  bool get isCustomItem => this._entity.isCustom;

  String get amount {
    return kFormatAmount(this._entity.ingredientNote.amount);
  }

  String get name {
    return this._entity.ingredientNote.ingredient.name;
  }

  bool get isNoLongerNeeded => this._entity.isBought;

  set noLongerNeeded(value) {
    if (value != this._entity.isBought) {
      this._entity.isBought = value;
      notifyListeners();
    }
  }

  void reordered() {
    notifyListeners();
  }

  IngredientNoteEntity toIngredientNoteEntity() {
    // var entity = MutableIngredientNote.empty();
    // var ingredient = MutableIngredient.empty();
    // ingredient.name = this._entity;
    // entity.amount = _amount;
    // entity.unitOfMeasure = this._uom != null ? this._uom.id : '';
    // entity.ingredient = ingredient;
    return this._entity.ingredientNote;
  }

  void updateFrom(RecipeIngredientModel entity) {
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    var uom = uomProvider.getUnitOfMeasureById(entity.unitOfMeasure);
    this._uom = uom;
    this._entity.ingredientNote.amount = entity.amount;
    this._entity.ingredientNote.ingredient.name = entity.ingredient.name;
    // this._parentModel.itemGotEdited();
    notifyListeners();
  }
}
