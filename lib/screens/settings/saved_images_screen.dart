import 'dart:io';

import 'package:cookza/constants.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedImagesScreen extends StatelessWidget {
  static final String id = 'savedImages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.localImages),
      ),
      body: FutureBuilder<List<File>>(
        future: _getImageFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<File> files = snapshot.data!;
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.imageDeleted),
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
