import 'dart:io';

import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageManager {
  Future<void> uploadRecipeImage(String recipeId, File file);
  Future<void> deleteRecipeImage(String recipeId);
  Future<String> getRecipeImageURL(String recipeId);
  String getRecipeImagePath(String recipeId);
  Future<File> getRecipeImageFile(String recipeID);
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

  @override
  Future<File> getRecipeImageFile(String recipeID) async {
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/$recipeID');
    if (!cacheFile.existsSync()) {
      StorageReference reference =
          _storage.ref().child(getRecipeImagePath(recipeID));
      var task = reference.writeToFile(cacheFile);
      await task.future;
    }

    return cacheFile;
  }
}
