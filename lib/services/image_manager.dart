import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageManager {
  Future<void> uploadRecipeImage(String recipeId, File file);
  Future<void> deleteRecipeImage(String recipeId);
  Future<String> getRecipeImageURL(String recipeId);
  String getRecipeImagePath(String recipeId);
}

class ImageManagerFirebase implements ImageManager {
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> deleteRecipeImage(String recipeId) async {
    StorageReference reference =
        _storage.ref().child(getRecipeImagePath(recipeId));
    // TODO: only call if really deleted... -> check in the model of the view
    await reference.delete();
  }

  @override
  Future<String> getRecipeImageURL(String path) async {
    StorageReference reference = _storage.ref().child(path);
    return await reference.getDownloadURL();
  }

  @override
  Future<void> uploadRecipeImage(String recipeId, File file) async {
    StorageReference reference =
        _storage.ref().child(getRecipeImagePath(recipeId));

    print('start upload');
    StorageUploadTask uploadTask = reference.putFile(
        file,
        StorageMetadata(customMetadata: {
          'recipe': recipeId,
        }));

    var result = await uploadTask.onComplete;
    print('upload completed: ${result.error}');
  }

  @override
  String getRecipeImagePath(String recipeId) {
    return 'images/recipe/$recipeId.jpg';
  }
}
