import 'dart:io';
import 'dart:typed_data';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageManager {
  Future<void> uploadRecipeImage(String recipeId, File file);
  Future<void> uploadRecipeImageFromBytes(String recipeId, Uint8List bytes);
  Future<void> deleteRecipeImage(RecipeEntity entity);
  Future<String> getRecipeImageURL(String recipeId);
  String getRecipeImagePath(String recipeId);
  Future<File?> getRecipeImageFile(RecipeEntity entity);
  Future<void> deleteLocalImage(String fileName);
}

class ImageManagerFirebase implements ImageManager {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> deleteRecipeImage(RecipeEntity entity) async {
    // delete local image file
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/${entity.id}.jpg');
    if (cacheFile.existsSync()) {
      cacheFile.deleteSync();
    }

    // return if the image does not have an image at all
    if (entity.image == null || entity.image!.isEmpty) {
      return;
    }

    // delete the cloud image
    Reference reference = _storage.ref().child(getRecipeImagePath(entity.id!));
    await reference.delete();
  }

  @override
  Future<String> getRecipeImageURL(String path) async {
    Reference reference = _storage.ref().child(path);
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
  Future<File?> getRecipeImageFile(RecipeEntity entity) async {
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

    if (entity.image != null && entity.image!.isNotEmpty) {
      try {
        Reference reference =
            _storage.ref().child(getRecipeImagePath(entity.id!));
        var task = reference.writeToFile(cacheFile);
        var taskSnapshot = await task;
        var bytes = taskSnapshot.bytesTransferred;
        print('$bytes downloaded');
      } catch (StorageException) {
        // the image for the given recipe does not exist
        return null;
      }
    } else {
      return null;
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
    Reference reference = _storage.ref().child(getRecipeImagePath(recipeId));

    // save local cache
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = File('$imageDirectory/$recipeId.jpg');

    cacheFile.writeAsBytesSync(bytes);

    // upload the file
    print('start upload');
    UploadTask uploadTask = reference.putFile(
        cacheFile,
        SettableMetadata(customMetadata: {
          'recipe': recipeId,
        }));

    var result = await uploadTask;
    print(
        'upload completed: ${result.state}, bytes: ${result.bytesTransferred}');
  }
}
