import 'dart:io';

import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/services/recipe/image_manager.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SavedImagesScreen extends StatelessWidget {
  static final String id = 'savedImages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Settings_Localimages)),
      ),
      body: FutureBuilder(
        future: _getImageFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<File> files = snapshot.data;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: files.length,
              itemBuilder: (context, index) {
                var file = files[index];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: AspectRatio(
                      aspectRatio: 2 / 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.center,
                            image: FileImage(files[index]),
                          ),
                        ),
                      ),
                    ),
                    title: Text(kDateFormatter.format(file.lastModifiedSync())),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await sl
                            .get<ImageManager>()
                            .deleteLocalImage(file.path.split('/').last);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(translate(Keys.Settings_Imagedeleted)),
                          ),
                        );
                      },
                    ),
                  ),
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
