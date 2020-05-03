import 'package:cookly/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_map.g.dart';

@JsonSerializable(includeIfNull: false)
class LocalImage {
  @JsonKey(nullable: false)
  String recipeReference;
  @JsonKey(nullable: false)
  String imageFilePath;

  factory LocalImage.fromJson(Map<String, dynamic> json) =>
      _$LocalImageFromJson(json);

  Map<String, dynamic> toJson() => _$LocalImageToJson(this);

  LocalImage(this.recipeReference, this.imageFilePath);
}

@JsonSerializable(includeIfNull: false)
class LocalImageList {
  @JsonKey(toJson: kListToJson)
  List<LocalImage> images;

  factory LocalImageList.fromJson(Map<String, dynamic> json) =>
      _$LocalImageListFromJson(json);

  Map<String, dynamic> toJson() => _$LocalImageListToJson(this);

  LocalImageList(this.images);
}
