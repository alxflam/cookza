import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/future_progress_dialog.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/screens/collections/qr_scanner.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cookza/l10n/app_localizations.dart';

class PopupMenuButtonChoices {
  final IconData _icon;
  const PopupMenuButtonChoices._internal(this._icon);
  IconData get icon => this._icon;

  static const DELETE = PopupMenuButtonChoices._internal(Icons.delete);
  static const EDIT = PopupMenuButtonChoices._internal(Icons.edit);
  static const ADD_USER = PopupMenuButtonChoices._internal(Icons.person_add);
  static const LEAVE = PopupMenuButtonChoices._internal(Icons.exit_to_app);
}

abstract class AbstractGroupScreen extends StatelessWidget {
  const AbstractGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupViewModel viewModel =
        buildGroupViewModel(ModalRoute.of(context)!.settings.arguments!);

    return ChangeNotifierProvider<GroupViewModel>.value(
      value: viewModel,
      child: Consumer<GroupViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.name),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: PopupMenuButtonChoices.EDIT,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.EDIT.icon),
                            Text(AppLocalizations.of(context).rename)
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: PopupMenuButtonChoices.ADD_USER,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.ADD_USER.icon),
                            Text(AppLocalizations.of(context).addUser)
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
                      PopupMenuItem(
                        value: PopupMenuButtonChoices.LEAVE,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.LEAVE.icon),
                            Text(AppLocalizations.of(context).leaveGroup)
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case PopupMenuButtonChoices.EDIT:
                        _renameCollection(context, model);
                        break;
                      case PopupMenuButtonChoices.DELETE:
                        _deleteCollection(context, model);
                        break;
                      case PopupMenuButtonChoices.ADD_USER:
                        _addUser(context, model);
                        break;
                      case PopupMenuButtonChoices.LEAVE:
                        _leaveGroup(context, model);
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ],
            ),
            body: Consumer<GroupViewModel>(
              builder: (context, model, _) {
                return FutureBuilder<List<UserEntity>>(
                  future: model.members(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    }

                    if (snapshot.data?.length == 1) {
                      return Center(
                        child: Text(AppLocalizations.of(context).singleMember),
                      );
                    }

                    var fb = sl.get<FirebaseProvider>();

                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data![index];
                        var isCurrentUser = fb.userUid == user.id;

                        final name = isCurrentUser
                            ? sl.get<SharedPreferencesProvider>().getUserName()
                            : user.name.isNotEmpty
                                ? user.name
                                : AppLocalizations.of(context).unknownUser;

                        return ListTile(
                          leading: _getLeadingUserIcon(user, isCurrentUser),
                          title: Text(name),
                          subtitle: isCurrentUser
                              ? Text(AppLocalizations.of(context).selfUser)
                              : const Text(''),
                          trailing: !isCurrentUser
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async =>
                                      await model.removeMember(user))
                              : null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getLeadingUserIcon(UserEntity user, bool isCurrentUser) {
    if (user.type == USER_TYPE.WEB_SESSION) {
      return const FaIcon(FontAwesomeIcons.desktop);
    }
    if (isCurrentUser) {
      return const FaIcon(FontAwesomeIcons.userCheck);
    }
    return const FaIcon(FontAwesomeIcons.user);
  }

  void _renameCollection(BuildContext sourceContext, GroupViewModel model) {
    // show a dialog to rename the collection
    showDialog(
      context: sourceContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: model.name);

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text(AppLocalizations.of(context).editGroup),
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: controller,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(context).groupName),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            style: kRaisedGreenButtonStyle,
                            onPressed: () {
                              model.rename(controller.text);
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.save),
                          ),
                          ElevatedButton(
                            style: kRaisedRedButtonStyle,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.cancel),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteCollection(BuildContext context, GroupViewModel model) async {
    final navigator = Navigator.of(context);

    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AlertDialogTitle(title: AppLocalizations.of(context).delete),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).confirmDelete(model.name),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: kRaisedGreyButtonStyle,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
            ),
            ElevatedButton(
              style: kRaisedRedButtonStyle,
              onPressed: () async {
                final navigator = Navigator.of(context);
                var future = model.delete();
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => SimpleDialog(
                          title: Center(
                              child: Text(AppLocalizations.of(context).delete)),
                          children: [FutureProgressDialog(future)],
                        ));

                navigator.pop(true);
              },
              child: Text(
                AppLocalizations.of(context).delete,
              ),
            ),
          ],
        );
      },
    );
    if (result) {
      navigator.pop();
    }
  }

  void _addUser(BuildContext context, GroupViewModel model) async {
    var result = await Navigator.pushNamed(context, QrScannerScreen.id);
    // ignore: use_build_context_synchronously
    if (result == null || (result is! String) || !context.mounted) {
      return;
    }

    try {
      var user = await model.addUserFromJson(result);
      // ignore: use_build_context_synchronously
      if (user == null || !context.mounted) {
        return;
      }
      await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(AppLocalizations.of(context).addUser),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(AppLocalizations.of(context).addedUser(user.name))],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: AlertDialogTitle(title: AppLocalizations.of(context).error),
            content: Text(AppLocalizations.of(context).invalidQRCode),
          ),
        );
      }
    }
  }

  void _leaveGroup(BuildContext context, GroupViewModel model) async {
    final navigator = Navigator.of(context);
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              AlertDialogTitle(title: AppLocalizations.of(context).leaveGroup),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).confirmLeave(model.name),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: kRaisedGreyButtonStyle,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
            ),
            ElevatedButton(
              style: kRaisedRedButtonStyle,
              onPressed: () async {
                final navigator = Navigator.of(context);
                await model.leaveGroup();
                navigator.pop(true);
              },
              child: Text(
                AppLocalizations.of(context).leaveGroup,
              ),
            ),
          ],
        );
      },
    );
    if (result) {
      navigator.pop();
    }
  }

  GroupViewModel buildGroupViewModel(Object arguments);
}
