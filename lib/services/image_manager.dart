import 'dart:io';
import 'dart:typed_data';

import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

abstract class ImageManager {
  Future<void> uploadRecipeImage(String recipeId, File file);
  Future<void> uploadRecipeImageFromBytes(String recipeId, Uint8List bytes);
  Future<void> deleteRecipeImage(String recipeId);
  Future<String> getRecipeImageURL(String recipeId);
  String getRecipeImagePath(String recipeId);
  Future<File> getRecipeImageFile(RecipeEntity entity);
  Future<void> deleteLocalImage(String fileName);
}

class ImageManagerFirebase implements ImageManager {
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> deleteRecipeImage(String recipeId) async {
    StorageReference reference =
        _storage.ref().child(getRecipeImagePath(recipeId));
    try {
      // TODO: only call if really deleted... -> check in the model of the view
      await reference.delete();
    } on PlatformException catch (e) {
      print(e.message);
      print(e);
    }
  }

  @override
  Future<String> getRecipeImageURL(String path) async {
    StorageReference reference = _storage.ref().child(path);
    return await reference.getDownloadURL();
  }

  @override
  Future<void> uploadRecipeImage(String recipeId, File file) async {
    return uploadRecipeImageFromBytes(recipeId, file.readAsBytesSync());
  }

  @override
  String getRecipeImagePath(String recipeId) {
    return 'images/recipe/$recipeId.jpg';
  }

  @override
  Future<File> getRecipeImageFile(RecipeEntity entity) async {
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/${entity.id}.jpg');

    if (cacheFile.existsSync()) {
      var imgDate = cacheFile.lastModifiedSync();
      var isBefore = imgDate.isBefore(entity.modificationDate);
      if (isBefore) {
        cacheFile.deleteSync();
      } else {
        return cacheFile;
      }
    }

    if (entity.image != null && entity.image.isNotEmpty) {
      try {
        StorageReference reference = _storage.ref().child(entity.image);
        var task = reference.writeToFile(cacheFile);
        var bytes = (await task.future).totalByteCount;
        print('$bytes downloaded');
      } catch (StorageException) {
        // the image for the given recipe does not exist
        return null;
      }
    } else {
      cacheFile = null;
    }

    return cacheFile;
  }

  @override
  Future<void> deleteLocalImage(String fileName) async {
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/$fileName');

    if (cacheFile.existsSync()) {
      cacheFile.deleteSync();
    }
  }

  @override
  Future<void> uploadRecipeImageFromBytes(
      String recipeId, Uint8List bytes) async {
    StorageReference reference =
        _storage.ref().child(getRecipeImagePath(recipeId));

    // save local cache
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/$recipeId.jpg');

    cacheFile.writeAsBytesSync(bytes);

    // upload the file
    print('start upload');
    StorageUploadTask uploadTask = reference.putFile(
        cacheFile,
        StorageMetadata(customMetadata: {
          'recipe': recipeId,
        }));

    var result = await uploadTask.onComplete;
    print('upload completed: ${result.error}');
  }
}
