import 'package:cookza/model/entities/abstract/recipe_entity.dart';

/// Compares the modification timestamp as some changes (like image or rating) can't be easily compared without network calls, hence just compare the modification timestamps.
/// May lead to a few too often refreshes of a [RecipeListTile] if e.g. only a ingredient changed, but tht is aceptable
bool changed(RecipeEntity a, RecipeEntity b) {
  return a.modificationDate != b.modificationDate;
}
