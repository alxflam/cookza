import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_shopping_list.g.dart';

dynamic _toJson(FirebaseIngredient ingredient) {
  return ingredient.toJson();
}

@JsonSerializable(includeIfNull: false)
class FirebaseShoppingListItem {
  @JsonKey(toJson: _toJson)
  FirebaseIngredient ingredient;

  @JsonKey(defaultValue: false)
  bool bought;

  @JsonKey(defaultValue: false)
  bool customItem;

  @JsonKey()
  int? index;

  FirebaseShoppingListItem(
      {required this.ingredient,
      required this.bought,
      required this.customItem,
      required this.index});

  factory FirebaseShoppingListItem.fromJson(Map<String, dynamic> json) {
    return _$FirebaseShoppingListItemFromJson(json);
  }

  factory FirebaseShoppingListItem.from(ShoppingListItemEntity entity) {
    var ingredient = FirebaseIngredient(
        ingredient: Ingredient(
            name: entity.ingredientNote.ingredient.name,
            recipeReference: entity.ingredientNote.ingredient.recipeReference),
        amount: entity.ingredientNote.amount,
        unitOfMeasure: entity.ingredientNote.unitOfMeasure);

    return FirebaseShoppingListItem(
        ingredient: ingredient,
        bought: entity.isBought,
        customItem: entity.isCustom,
        index: entity.index);
  }

  Map<String, dynamic> toJson() => _$FirebaseShoppingListItemToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FirebaseShoppingListDocument {
  @JsonKey(ignore: true)
  String? documentID;

  @JsonKey(toJson: kListToJson)
  List<FirebaseShoppingListItem> items;

  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime dateFrom;

  @JsonKey(toJson: kDateToJson, fromJson: kDateFromJson)
  DateTime dateUntil;

  @JsonKey()
  String groupID;

  FirebaseShoppingListDocument(
      {this.documentID,
      required this.items,
      required this.groupID,
      required this.dateFrom,
      required this.dateUntil});

  factory FirebaseShoppingListDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseShoppingListDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseShoppingListDocumentToJson(this);

  static FirebaseShoppingListDocument from(ShoppingListEntity entity) {
    var items =
        entity.items.map((e) => FirebaseShoppingListItem.from(e)).toList();
    return FirebaseShoppingListDocument(
        items: items,
        groupID: entity.groupID,
        dateFrom: entity.dateFrom,
        dateUntil: entity.dateUntil);
  }
}
