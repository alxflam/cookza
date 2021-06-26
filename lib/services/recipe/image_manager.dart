import 'dart:io';
import 'dart:typed_data';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class ImageManager {
  Future<void> uploadRecipeImage(String recipeId, File file);
  Future<void> uploadRecipeImageFromBytes(String recipeId, Uint8List bytes);
  Future<void> deleteRecipeImage(String recipeId);
  Future<String> getRecipeImageURL(String recipeId);
  String getRecipeImagePath(String recipeId);
  Future<File?> getRecipeImageFile(RecipeEntity entity);
  Future<void> deleteLocalImage(String fileName);
}

class ImageManagerFirebase implements ImageManager {
  final FirebaseStorage _storage = sl.get<FirebaseStorage>();

  @override
  Future<void> deleteRecipeImage(String recipeId) async {
    // delete local image file
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    File cacheFile = cacheFilePath(imageDirectory, recipeId);
    if (cacheFile.existsSync()) {
      await cacheFile.delete();
      print('deleted file: ${cacheFile.path}');
    }

    // delete the cloud image
    Reference reference = _storage.ref().child(getRecipeImagePath(recipeId));
    await reference.delete();
  }

  File cacheFilePath(String imageDirectory, String id) {
    return File('$imageDirectory/$id.jpg');
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
    var cacheFile = cacheFilePath(imageDirectory, entity.id!);

    if (cacheFile.existsSync()) {
      var imgDate = await cacheFile.lastModified();
      var isBefore = imgDate.isBefore(entity.modificationDate);
      if (isBefore) {
        await cacheFile.delete();
      } else {
        return cacheFile;
      }
    }

    if (entity.image != null && entity.image!.isNotEmpty) {
      try {
        Reference reference =
            _storage.ref().child(getRecipeImagePath(entity.id!));
        await reference.writeToFile(cacheFile);
      } on Exception catch (e) {
        await sl
            .get<ExceptionHandler>()
            .reportException(e, StackTrace.empty, DateTime.now());
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
      await cacheFile.delete();
    }
  }

  @override
  Future<void> uploadRecipeImageFromBytes(
      String recipeId, Uint8List bytes) async {
    // save or update the local cache
    var imageDirectory = await sl.get<StorageProvider>().getImageDirectory();
    var cacheFile = cacheFilePath(imageDirectory, recipeId);
    await FileImage(cacheFile).evict(); // clear the image cache

    // flush to be sure wqe don't still show outdated data
    await cacheFile.writeAsBytes(bytes, flush: true);
    print('saved local file: ${cacheFile.path}');

    // upload the file
    Reference reference = _storage.ref().child(getRecipeImagePath(recipeId));
    print('start upload');
    UploadTask uploadTask = reference.putFile(
        cacheFile,
        SettableMetadata(customMetadata: {
          'recipe': recipeId,
        }));

    await uploadTask;
    print('upload completed');
  }
}
