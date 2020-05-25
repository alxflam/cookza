import 'package:cookly/constants.dart';
import 'package:cookly/model/json/shopping_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_lists.g.dart';

@JsonSerializable(includeIfNull: false)
class ShoppingLists {
  @JsonKey(nullable: false)
  int modelVersion;

  @JsonKey(toJson: kListToJson)
  List<ShoppingList> items;

  ShoppingLists({this.modelVersion, this.items}) {
    this.modelVersion = 1;
    if (this.items == null) {
      this.items = [];
    }
  }

  factory ShoppingLists.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListsFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListsToJson(this);
}
