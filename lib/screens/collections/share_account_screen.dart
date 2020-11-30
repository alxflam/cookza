import 'dart:async';
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
                              _getUserNameField(context, model),
                            ]),
                      );
                    }),
                    Builder(builder: (context) {
                      // if no username has been entered yet
                      if (!model.hasName) {
                        // open a dialog for the user name input
                        _openNameDialog(context, model);

                        // and return an emmpty container
                        return Container();
                      }

                      var json = model.jsonUser.toJson();
                      var data = jsonEncode(json);
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: PaddedQRCode(data, 400, 400));
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

  void _openNameDialog(BuildContext context, ShareAccountScreenModel model) {
    Timer.run(() async {
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(fontSize: 20),
                        autofocus: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pop(context, model);
                          },
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
    });
  }

  Widget _getUserNameField(
      BuildContext context, ShareAccountScreenModel model) {
    var userName = model.userName;

    return Expanded(
      child: Card(
        child: ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(userName),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _openNameDialog(context, model);
            },
          ),
        ),
      ),
    );
  }
}
