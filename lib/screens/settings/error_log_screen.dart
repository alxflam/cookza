import 'package:cookza/model/json/exception_log.dart';
import 'package:cookza/viewmodel/settings/error_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class PopupMenuButtonChoices {
  final _icon;
  const PopupMenuButtonChoices._internal(this._icon);
  IconData get icon => this._icon;

  static const SHARE = PopupMenuButtonChoices._internal(Icons.share);
  static const DELETE = PopupMenuButtonChoices._internal(Icons.delete);
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
          title: Text(AppLocalizations.of(context).errorLog),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.SHARE.icon),
                      Text(AppLocalizations.of(context).share),
                    ],
                  ),
                  value: PopupMenuButtonChoices.SHARE,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.DELETE.icon),
                      Text(AppLocalizations.of(context).delete)
                    ],
                  ),
                  value: PopupMenuButtonChoices.DELETE,
                ),
              ];
            }, onSelected: (value) async {
              switch (value) {
                case PopupMenuButtonChoices.SHARE:
                  var content = await _model.errorsAsText;
                  await ShareExtend.share(content, 'text');
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
                      child: Text(AppLocalizations.of(context).noErrorLogEntry),
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
