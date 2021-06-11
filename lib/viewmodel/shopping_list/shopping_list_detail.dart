import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class ShoppingListModel extends ChangeNotifier {
  late MutableShoppingList _listEntity;

  static final int _shoppingListDays =
      sl.get<SharedPreferencesProvider>().getMealPlanWeeks() * 7;

  final DateTime _lastDate;

  final List<MutableShoppingListItem> _items = [];
  bool _initalized = false;

  ShoppingListModel.from(ShoppingListEntity listEntity)
      : this._listEntity = MutableShoppingList.of(listEntity),
        _lastDate = DateTime.now().add(Duration(days: _shoppingListDays));

  ShoppingListModel.empty({String? groupID})
      : this._lastDate = DateTime.now().add(Duration(days: _shoppingListDays)) {
    this._listEntity = MutableShoppingList.newList(
        groupID ?? '', DateTime.now(), initialEndDate);
  }

  bool get initialized => this._initalized;

  Future<List<ShoppingListItemModel>> getItems() async {
    // lazy initialize on first get call
    if (this.initialized) {
      // sort items
      // TODO: should be added again?
      // this._sortItems();
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

    // generate items from current meal plan
    List<MutableShoppingListItem> generatedItems = [];
    try {
      generatedItems = await sl
          .get<ShoppingListItemsGenerator>()
          .generateItems(this._listEntity);
    } on FirebaseException catch (e) {
      var context = sl.get<NavigatorService>().currentContext;
      // make sure that case is logged
      await sl.get<ExceptionHandler>().reportException(
          '${AppLocalizations.of(context!).missingRecipeAccess}: ${e.toString()}',
          StackTrace.current,
          DateTime.now());
      // may happen if the shopping list contains a recipe from a group the current user does not have read access to
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).missingRecipeAccess)));
    }

    // processed generated already bought and/or reordered items
    var persisted = this
        ._listEntity
        .items
        .where((e) => !e.isCustom && (e.isBought || e.index != null))
        .toList();
    for (var item in persisted) {
      // TODO: keep item even if amount changed! => less changes
      var generatedItem = generatedItems.firstWhereOrNull((e) =>
          e.ingredientNote.amount == item.ingredientNote.amount &&
          e.ingredientNote.ingredient.name ==
              item.ingredientNote.ingredient.name &&
          e.ingredientNote.unitOfMeasure == item.ingredientNote.unitOfMeasure);
      if (generatedItem != null) {
        // exactly the same item has been generated, then use the persisted one
        generatedItems.remove(generatedItem);
        this._items.add(MutableShoppingListItem.ofEntity(item));
      } else {
        // the generation of ingredients did not produce an identical item, then forget about the persisted state
        // most likely the meal plan changed: a recipe was removed or its ingredient changed
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
    const kMaxIndex = 1000;
    this._items.sort((a, b) {
      if (a.index >= 0 || b.index >= 0) {
        // do not sort -1 (index not set) at the beginning
        int firstIndex = a.index < 0 ? kMaxIndex : a.index;
        int secondIndex = b.index < 0 ? kMaxIndex : b.index;

        return firstIndex.compareTo(secondIndex);
      }
      if (a.isBought && !b.isBought) {
        return 1;
      }
      if (b.isBought && !a.isBought) {
        return -1;
      }
      return a.ingredientNote.ingredient.name
          .compareTo(b.ingredientNote.ingredient.name);
    });
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
    // get the item to be reordered
    var item = _items.removeAt(oldIndex);
    // reorder in list
    var targetIndex = newIndex > _items.length ? newIndex - 1 : newIndex;
    // set the desired index for persistence
    item.index = targetIndex;
    this._items.insert(targetIndex, item);
    // persist changes
    this._save();
    // and update the UI
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

  void _save() async {
    // set the  index for every element
    // as we have to save the index of every element to make sure the same order can be restored later on
    // for (var i = 0; i < this._items.length; i++) {
    //   this._items[i].index = i;
    // }

    // only save custom items, bought items and items with an explicit index (hence has been moved manually)
    var customItems = this
        ._items
        .where((a) => a.isCustom || a.isBought || a.index >= 0)
        .toList();

    // remove all entities
    this._listEntity.clearItems();

    // add valid items
    for (var item in customItems) {
      // add to entity
      this._listEntity.addItem(item);
    }

    // then save the changes - creates the list if it does not yet exist
    var updatedEntity =
        await sl.get<ShoppingListManager>().createOrUpdate(this._listEntity);

    // and update the document id as it changed (usually only if the list get's created on the first save)
    this._listEntity.id = updatedEntity.id!;
  }

  void itemGotEdited(ShoppingListItemModel changedEntity) {
    this._save();
    this._sortItems();
    notifyListeners();
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
  UnitOfMeasure? _uom;
  final MutableShoppingListItem _entity;

  ShoppingListItemModel.ofEntity(ShoppingListItemEntity entity)
      : this._entity = entity as MutableShoppingListItem {
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    if (entity.ingredientNote.unitOfMeasure != null &&
        entity.ingredientNote.unitOfMeasure!.trim().isNotEmpty) {
      var uom = uomProvider
          .getUnitOfMeasureById(entity.ingredientNote.unitOfMeasure!);
      this._uom = uom;
    }
  }

  String get uom {
    if (_uom == null) {
      return '';
    }
    return _uom!
        .getDisplayName(this._entity.ingredientNote.amount?.toInt() ?? 1);
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
      if (value) {
        // reset index to make sure checked off items are sorted to the end
        this._entity.index = -1;
      }
      notifyListeners();
    }
  }

  IngredientNoteEntity toIngredientNoteEntity() {
    return this._entity.ingredientNote;
  }

  void updateFrom(RecipeIngredientModel entity) {
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    this._uom = null;
    if (entity.unitOfMeasure != null && entity.unitOfMeasure!.isNotEmpty) {
      var uom = uomProvider.getUnitOfMeasureById(entity.unitOfMeasure!);
      this._uom = uom;
    }
    this._entity.ingredientNote.amount = entity.amount;
    this._entity.ingredientNote.ingredient.name = entity.ingredient.name;
    notifyListeners();
  }
}
