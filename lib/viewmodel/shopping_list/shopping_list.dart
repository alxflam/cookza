import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/shopping_list.dart';
import 'package:cookly/services/ingredients_calculator.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:flutter/material.dart';

class ShoppingListOverviewModel extends ChangeNotifier {
  List<ShoppingListModel> _lists = [];

  ShoppingListOverviewModel.of(List<ShoppingList> lists) {
    for (var item in lists) {
      _lists.add(ShoppingListModel.of(item));
    }
  }

  List<ShoppingListModel> getLists() {
    return _lists;
  }
}

class ShoppingListModel extends ChangeNotifier {
  DateTime _dateFrom;
  DateTime _dateEnd;

  static int _shoppingListDays =
      sl.get<SharedPreferencesProvider>().getMealPlanWeeks() * 7;
  DateTime _lastDate;
  DateTime _firstDate;

  List<IngredientNote> _requiredIngredients = [];
  List<IngredientNote> _availableIngredients = [];
  Map<String, int> _recipeReferences = {};
  List<ShoppingListItemModel> _items = [];

  MealPlanCollectionEntity _collection;

  ShoppingListModel.from(
      this._dateFrom, this._dateEnd, this._collection, this._recipeReferences) {
    _firstDate = DateTime.now();
    _lastDate = _firstDate.add(Duration(days: _shoppingListDays));
    // TODO: null values due to notes - handle them earlier?
    // _recipeReferences.removeWhere((key, value) => key == null || value == null);
  }

  ShoppingListModel.empty()
      : this.from(DateTime.now(),
            DateTime.now().add(Duration(days: _shoppingListDays)), null, {});

  Future<List<ShoppingListItemModel>> getItems() async {
    // lazy initialize on first get call
    if (_items.isNotEmpty && _recipeReferences.isNotEmpty) {
      return this._items;
    }

    var mealPlanModel = await sl
        .get<MealPlanManager>()
        .getMealPlanByCollectionID(this._collection.id);
    print('model received');
    MealPlanViewModel mealPlanViewModel = MealPlanViewModel.of(mealPlanModel);
    print('view model created');

    // collect all recipes planned for the given duration
    for (var item in mealPlanViewModel.entries) {
      print('check item $item whether its in the date range');
      if (item.recipes.isNotEmpty &&
          item.date.isBefore(this._dateEnd.add(Duration(days: 1))) &&
          item.date.isAfter(this._dateFrom.subtract(Duration(days: 1)))) {
        for (var recipe in item.recipes) {
          if (!recipe.isNote) {
            _recipeReferences.update(recipe.id, (value) => value,
                ifAbsent: () => recipe.servings);
          }
        }
      }
    }

    // next create a set of the required ingredients
    print('get ingredients');
    var ingredients =
        await sl.get<IngredientsCalculator>().getIngredients(_recipeReferences);
    print('ingredients received ${ingredients.length}');
    // at last create the view model representation of the list of ingredients
    var uomProvider = sl.get<UnitOfMeasureProvider>();
    for (var item in ingredients) {
      var itemModel = ShoppingListItemModel(
          uomProvider.getUnitOfMeasureById(item.unitOfMeasure),
          item.amount,
          item.ingredient.name,
          false,
          this);
      _items.add(itemModel);
    }

    return _items;
  }

  void _sortItems() {
    this._items.sort((a, b) {
      if (a.isNoLongerNeeded) {
        return 1;
      }
      if (b.isNoLongerNeeded) {
        return -1;
      }
      return a.getName().compareTo(b.getName());
    });
    notifyListeners();
  }

  ShoppingListModel.of(ShoppingList model) {
    this._dateFrom = model.dateFrom;
    this._dateEnd = model.dateEnd;
    this._recipeReferences.addAll(model.recipeReferences);
  }

  String get shortTitle {
    return this._dateFrom.day.toString() +
        '.' +
        this._dateFrom.month.toString() +
        ' - ' +
        this._dateEnd.day.toString() +
        '.' +
        this._dateEnd.month.toString();
  }

  String getDateFrom() {
    return kDateFormatter.format(_dateFrom);
  }

  String getDateEnd() {
    return kDateFormatter.format(_dateEnd);
  }

  DateTime get dateFrom => _dateFrom;

  DateTime get dateEnd => _dateEnd;

  void decrementDateFrom() {
    if (this._dateFrom.isAfter(DateTime.now())) {
      this._dateFrom = this._dateFrom.subtract(Duration(days: 1));
      notifyListeners();
    }
  }

  void incrementDateFrom() {
    if (this._dateFrom.add(Duration(days: 1)).isBefore(_dateEnd)) {
      this._dateFrom = this._dateFrom.add(Duration(days: 1));
      notifyListeners();
    }
  }

  void incrementDateEnd() {
    if (this._dateEnd.add(Duration(days: 1)).isBefore(_lastDate)) {
      this._dateEnd = this._dateEnd.add(Duration(days: 1));
      notifyListeners();
    }
  }

  void decrementDateEnd() {
    if (this._dateEnd.subtract(Duration(days: 1)).isAfter(this._dateFrom)) {
      this._dateEnd = this._dateEnd.subtract(Duration(days: 1));
      notifyListeners();
    }
  }

  MealPlanCollectionEntity get collection => this._collection;

  set collection(MealPlanCollectionEntity value) {
    this._collection = value;
  }
}

class ShoppingListItemModel extends ChangeNotifier {
  UnitOfMeasure _uom;
  double _amount;
  String _name;
  bool _isNoLongerNeeded;
  ShoppingListModel _parentModel;

  ShoppingListItemModel(this._uom, this._amount, this._name,
      this._isNoLongerNeeded, this._parentModel);

  String get uom {
    // TODO: there should be a null uom!
    if (_uom == null) {
      return '';
    }
    return _uom.getDisplayName(this._amount.toInt());
  }

  String getAmount() {
    return kFormatAmount(this._amount);
  }

  String getName() {
    return this._name;
  }

  bool get isNoLongerNeeded => _isNoLongerNeeded;

  void setNoLongerNeeded(value) {
    if (value != this._isNoLongerNeeded) {
      this._isNoLongerNeeded = value;
      this._parentModel._sortItems();
      notifyListeners();
    }
  }
}
