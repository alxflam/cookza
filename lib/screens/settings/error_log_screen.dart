import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/json/exception_log.dart';
import 'package:cookly/viewmodel/settings/error_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const SHARE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Share, Icons.share);
  static const DELETE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Delete, Icons.delete);
}

class ErrorLogScreen extends StatelessWidget {
  static final String id = 'errorLog';

  @override
  Widget build(BuildContext context) {
    var _model = ErrorScreenModel();

    return ChangeNotifierProvider.value(
      value: _model,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate(Keys.Settings_Errorlog)),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.SHARE.icon),
                      Text(PopupMenuButtonChoices.SHARE.toString())
                    ],
                  ),
                  value: PopupMenuButtonChoices.SHARE,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.DELETE.icon),
                      Text(PopupMenuButtonChoices.DELETE.toString())
                    ],
                  ),
                  value: PopupMenuButtonChoices.DELETE,
                ),
              ];
            }, onSelected: (value) async {
              switch (value) {
                case PopupMenuButtonChoices.SHARE:
                  var content = await _model.errorsAsText;
                  ShareExtend.share(content, 'text');
                  break;
                case PopupMenuButtonChoices.DELETE:
                  _model.clearLog();
                  break;
              }
            }),
          ],
        ),
        body: Consumer<ErrorScreenModel>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.errors,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  List<ExceptionItem> files = snapshot.data;
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      var logEntry = files[index];

                      return ExceptionEntry(logEntry);
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text('Hooray! No errors have been logged'),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class ExceptionEntry extends StatelessWidget {
  final ExceptionItem exception;

  static final kTitleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  const ExceptionEntry(this.exception);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              exception.date.toIso8601String(),
              style: kTitleStyle,
            ),
            Text(
              exception.error,
              style: kTitleStyle,
            ),
            Builder(builder: (context) {
              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(exception.stackTrace),
              );
            })
          ],
        ),
      ),
    );
  }
}
