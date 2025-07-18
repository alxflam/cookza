import 'dart:io';

import 'package:cookza/constants.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';

class SavedImagesScreen extends StatelessWidget {
  static const String id = 'savedImages';

  const SavedImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).localImages),
      ),
      body: FutureBuilder<List<File>>(
        future: _getImageFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<File> files = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: files.length,
              itemBuilder: (context, index) {
                var file = files[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final localizations = AppLocalizations.of(context);
                        await sl
                            .get<ImageManager>()
                            .deleteLocalImage(file.path.split('/').last);
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(localizations.imageDeleted),
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
