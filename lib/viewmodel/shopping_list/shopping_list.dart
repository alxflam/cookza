import 'package:cookly/constants.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/shopping_list.dart';
import 'package:cookly/services/service_locator.dart';
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

  List<IngredientNote> _requiredIngredients = [];
  List<IngredientNote> _availableIngredients = [];
  Map<String, int> _recipeReferences = {};
  List<ShoppingListItemModel> _items = [];

  ShoppingListModel(this._dateFrom, this._dateEnd, this._recipeReferences);

  List<ShoppingListItemModel> getItems(BuildContext context) {
    // lazy initialize on first get call
    if (_items.isEmpty && _recipeReferences.isNotEmpty) {
      var locale = Localizations.localeOf(context);

      // TODO: pass the viewmodel directly as a constructor argument...
      MealPlanViewModel mealPlan = MealPlanViewModel.of(null);

      // collect all recipes planned for the given duration
      for (var item in mealPlan.entries) {
        if (item.recipes.isNotEmpty &&
            item.date.isBefore(this._dateEnd.add(Duration(days: 1))) &&
            item.date.isAfter(this._dateFrom.subtract(Duration(days: 1)))) {
          for (var recipe in item.recipes) {
            _recipeReferences.update(recipe.id, (value) => value,
                ifAbsent: () => recipe.servings);
          }
        }
      }

      // next create a set of the required ingredients
      // TODO: next thing to fix after firestore migration...
      // var ingredients =
      //     sl.get<IngredientsCalculator>().getIngredients(_recipeReferences);
      var ingredients = [];
      // at last create the view model representation of the list of ingredients
      var uomProvider = sl.get<UnitOfMeasureProvider>();
      for (var item in ingredients) {
        var itemModel = ShoppingListItemModel(
            uomProvider.getUnitOfMeasureById(item.unitOfMeasure),
            item.amount,
            item.ingredient.name,
            false);
        _items.add(itemModel);
      }
    }

    return _items;
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
    this._dateFrom = this._dateFrom.subtract(Duration(days: 1));
    notifyListeners();
  }

  void incrementDateFrom() {
    this._dateFrom = this._dateFrom.add(Duration(days: 1));
    notifyListeners();
  }

  void incrementDateEnd() {
    this._dateEnd = this._dateEnd.add(Duration(days: 1));
    notifyListeners();
  }

  void decrementDateEnd() {
    this._dateEnd = this._dateEnd.subtract(Duration(days: 1));
    notifyListeners();
  }

  String toShareString() {
    var buffer = StringBuffer();

    if (_items.isNotEmpty) {
      buffer.writeln('*cookly Shopping List*');
    }

    for (var item in this._items) {
      buffer.writeln('${item.getName()} (${item.getAmount()} ${item.uom})');
    }

    return buffer.toString();
  }
}

class ShoppingListItemModel extends ChangeNotifier {
  UnitOfMeasure _uom;
  double _amount;
  String _name;
  bool _isNoLongerNeeded;
  ShoppingListItemModel(
      this._uom, this._amount, this._name, this._isNoLongerNeeded);

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
      notifyListeners();
    }
  }
}
