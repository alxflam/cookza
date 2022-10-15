import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/viewmodel/collections/share_account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareAccountScreen extends StatelessWidget {
  static const String id = 'shareAccount';
  final GlobalKey _globalKey = GlobalKey();

  ShareAccountScreen({Key? key}) : super(key: key);

  Future<Uint8List> _widgetToImageBytes() async {
    final boundary = this._globalKey.currentContext!.findRenderObject();
    if (boundary is RenderRepaintBoundary) {
      var image = await boundary.toImage(pixelRatio: 3);
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }
    throw 'this is not expected';
  }

  @override
  Widget build(BuildContext context) {
    var shareModel = ShareAccountScreenModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).shareAccount),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final localizations = AppLocalizations.of(context);
              var bytes = await _widgetToImageBytes();
              String directory =
                  await sl.get<StorageProvider>().getTempDirectory();
              var file = File('$directory/${shareModel.userName}.png');
              await file.writeAsBytes(bytes);
              await Share.shareXFiles([XFile(file.path)],
                  text: localizations.addMeToGroup,
                  subject: localizations.shareQRCodeSubject);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _openNameDialog(context, shareModel);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: shareModel,
        builder: (context, child) {
          return Consumer<ShareAccountScreenModel>(
            builder: (context, model, _) {
              return SingleChildScrollView(
                child: RepaintBoundary(
                  key: this._globalKey,
                  child: Builder(
                    builder: (context) {
                      // if no username has been entered yet
                      if (!model.hasName) {
                        // open a dialog for the user name input
                        _openNameDialog(context, model);
                        // and return an emmpty container
                        return Container();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Builder(builder: (context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _getUserNameField(context, model),
                                  ]),
                            );
                          }),
                          Builder(builder: (context) {
                            var json = model.jsonUser.toJson();
                            var data = jsonEncode(json);
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: PaddedQRCode(data, 300, 300),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openNameDialog(BuildContext context, ShareAccountScreenModel model) {
    Timer.run(
      () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).enterUsername),
              content: Builder(
                builder: (context) {
                  final nameController =
                      TextEditingController(text: model.userName);
                  nameController.addListener(
                    () {
                      model.userName = nameController.text;
                    },
                  );

                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: nameController,
                          style: const TextStyle(fontSize: 20),
                          autofocus: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            style: kRaisedGreenButtonStyle,
                            onPressed: () {
                              Navigator.pop(context, model);
                            },
                            child: const Icon(Icons.check),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );

        if (model.hasName) {
          model.refresh();
        }
      },
    );
  }

  Widget _getUserNameField(
      BuildContext context, ShareAccountScreenModel model) {
    var userName = model.userName;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 35,
              child: const Image(
                width: 35,
                image: AssetImage(kIconTransparent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
