import 'dart:convert';

import 'package:cookza/components/padded_qr_code.dart';
import 'package:cookza/viewmodel/collections/share_account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShareAccountScreen extends StatelessWidget {
  static final String id = 'shareAccount';

  @override
  Widget build(BuildContext context) {
    var _model = ShareAccountScreenModel();
    // TODO move to drawer header as avatar with gesture detection to navigate to this screen
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).shareAccount),
      ),
      body: ChangeNotifierProvider.value(
        value: _model,
        builder: (context, child) {
          return Consumer<ShareAccountScreenModel>(
            builder: (context, model, _) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Builder(builder: (context) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _getUserNameField(model),
                              IconButton(
                                icon: model.isEditMode
                                    ? Icon(Icons.check)
                                    : Icon(Icons.edit),
                                onPressed: () {
                                  model.isEditMode = !model.isEditMode;
                                },
                              )
                            ]),
                      );
                    }),
                    Builder(builder: (context) {
                      if (!model.hasName) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context).enterUsername)
                          ],
                        );
                      }

                      var json = model.jsonUser.toJson();
                      var data = jsonEncode(json);
                      return PaddedQRCode(data, 400, 400);
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getUserNameField(ShareAccountScreenModel model) {
    var userName = model.userName;
    if (model.isEditMode) {
      var controller = TextEditingController(text: userName);

      return Expanded(
        child: TextFormField(
          controller: controller,
          maxLines: 1,
          maxLength: 20,
          autofocus: true,
          onChanged: (value) {
            model.userName = value;
          },
          // TODO: localized text
          decoration: InputDecoration(hintText: '§Your external user name'),
        ),
      );
    }
    return Text(userName);
  }
}
