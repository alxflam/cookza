import 'dart:io';

import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

class SavedImagesScreen extends StatelessWidget {
  static final String id = 'savedImages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('§Saved Images'),
      ),
      body: FutureBuilder(
        future: _getImageFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<File> files = snapshot.data;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                var name = files[index].path.split('/').last;
                var id = name.split('.').first;
                var recipes = [];
                // sl.get<ImageManager>().appProfile.getRawRecipes([id]);

                var recipeName = recipes == null || recipes.isEmpty
                    ? 'Deleted'
                    : recipes.first.name;
                return ListTile(
                  title: Text('Name: $name, Recipe: $recipeName'),
                  subtitle: Text('Path: ${files[index].path}'),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<List<File>> _getImageFiles() async {
    String path = await sl.get<StorageProvider>().getImageDirectory();
    var files = Directory(path).listSync();
    List<File> result = [];
    for (var entry in files) {
      if (entry is File) {
        result.add(entry);
      }
    }
    return result;
  }
}
