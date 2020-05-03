// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalImage _$LocalImageFromJson(Map<String, dynamic> json) {
  return LocalImage(
    json['recipeReference'] as String,
    json['imageFilePath'] as String,
  );
}

Map<String, dynamic> _$LocalImageToJson(LocalImage instance) =>
    <String, dynamic>{
      'recipeReference': instance.recipeReference,
      'imageFilePath': instance.imageFilePath,
    };

LocalImageList _$LocalImageListFromJson(Map<String, dynamic> json) {
  return LocalImageList(
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : LocalImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LocalImageListToJson(LocalImageList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('images', kListToJson(instance.images));
  return val;
}
