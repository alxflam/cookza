import 'package:cookza/model/json/exception_log.dart';
import 'package:cookza/viewmodel/settings/error_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PopupMenuButtonChoices {
  final IconData _icon;
  const PopupMenuButtonChoices._internal(this._icon);
  IconData get icon => this._icon;

  static const SHARE = PopupMenuButtonChoices._internal(Icons.share);
  static const DELETE = PopupMenuButtonChoices._internal(Icons.delete);
}

class ErrorLogScreen extends StatelessWidget {
  static const String id = 'errorLog';

  const ErrorLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ErrorScreenModel();

    return ChangeNotifierProvider.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).errorLog),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: PopupMenuButtonChoices.SHARE,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.SHARE.icon),
                      Text(AppLocalizations.of(context).share),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: PopupMenuButtonChoices.DELETE,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.DELETE.icon),
                      Text(AppLocalizations.of(context).delete)
                    ],
                  ),
                ),
              ];
            }, onSelected: (value) async {
              switch (value) {
                case PopupMenuButtonChoices.SHARE:
                  var content = await model.errorsAsText;
                  await Share.share(content);
                  break;
                case PopupMenuButtonChoices.DELETE:
                  model.clearLog();
                  break;
              }
            }),
          ],
        ),
        body: Consumer<ErrorScreenModel>(
          builder: (context, value, child) {
            return FutureBuilder<List<ExceptionItem>>(
              future: value.errors,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<ExceptionItem> files = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      var logEntry = files[index];

                      return ExceptionEntry(logEntry);
                    },
                  );
                } else {
                  return Center(
                    child: Text(AppLocalizations.of(context).noErrorLogEntry),
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

  static const kTitleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  const ExceptionEntry(this.exception, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        exception.date.toIso8601String(),
        style: kTitleStyle,
      ),
      subtitle: Text(
        exception.error,
      ),
      onTap: () {
        /// show the stacktrace only if requested in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).errorLog),
              content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Text(exception.stackTrace ?? ''),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
