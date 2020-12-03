import 'package:cookza/components/future_progress_dialog.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/mobile/qr_scanner.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupMenuButtonChoices {
  final _icon;
  const PopupMenuButtonChoices._internal(this._icon);
  IconData get icon => this._icon;

  static const DELETE = PopupMenuButtonChoices._internal(Icons.delete);
  static const EDIT = PopupMenuButtonChoices._internal(Icons.edit);
  static const ADD_USER = PopupMenuButtonChoices._internal(Icons.person_add);
  static const LEAVE = PopupMenuButtonChoices._internal(Icons.exit_to_app);
}

abstract class AbstractGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GroupViewModel _viewModel =
        buildGroupViewModel(ModalRoute.of(context).settings.arguments);

    return ChangeNotifierProvider<GroupViewModel>.value(
      value: _viewModel,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.EDIT.icon),
                            Text(AppLocalizations.of(context).rename)
                          ],
                        ),
                        value: PopupMenuButtonChoices.EDIT,
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.ADD_USER.icon),
                            Text(AppLocalizations.of(context).addUser)
                          ],
                        ),
                        value: PopupMenuButtonChoices.ADD_USER,
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
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.LEAVE.icon),
                            Text(AppLocalizations.of(context).leaveGroup)
                          ],
                        ),
                        value: PopupMenuButtonChoices.LEAVE,
                      ),
                    ];
                  },
                  onSelected: (value) {
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

                    if (snapshot.data.length == 1) {
                      return Center(
                        child: Text(AppLocalizations.of(context).singleMember),
                      );
                    }

                    var fb = sl.get<FirebaseProvider>();

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data[index];
                        var isCurrentUser = fb.userUid == user.id;

                        return ListTile(
                          leading: _getLeadingUserIcon(user, isCurrentUser),
                          title: Text(user.name ?? 'unknown'),
                          subtitle:
                              isCurrentUser ? Text('That\'s me') : Text(''),
                          trailing: !isCurrentUser
                              ? IconButton(
                                  icon: Icon(Icons.delete),
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
      return FaIcon(FontAwesomeIcons.desktop);
    }
    if (isCurrentUser) {
      return FaIcon(FontAwesomeIcons.userCheck);
    }
    return FaIcon(FontAwesomeIcons.user);
  }

  void _renameCollection(BuildContext _context, GroupViewModel model) {
    // show a dialog to rename the collection
    showDialog(
      context: _context,
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
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
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
                          RaisedButton(
                              child: Icon(Icons.save),
                              color: Colors.green,
                              onPressed: () {
                                model.rename(controller.text);
                                Navigator.pop(context);
                              }),
                          RaisedButton(
                              child: Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
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
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).delete),
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
            FlatButton(
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).delete,
              ),
              color: Colors.red,
              onPressed: () async {
                var future = model.delete();
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: SimpleDialog(
                      title: Center(
                          child: Text(AppLocalizations.of(context).delete)),
                      children: [FutureProgressDialog(future)],
                    ));

                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (result) {
      Navigator.pop(context);
    }
  }

  void _addUser(BuildContext context, GroupViewModel model) async {
    // scan a qr code
    var scanResult = await sl.get<QRScanner>().scanUserQRCode();
    if (scanResult != null) {
      // then add the user
      await model.addUser(scanResult.id, scanResult.name);
    }
  }

  void _leaveGroup(BuildContext context, GroupViewModel model) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).delete),
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
            FlatButton(
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).leaveGroup,
              ),
              color: Colors.red,
              onPressed: () async {
                await model.leaveGroup();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (result) {
      Navigator.pop(context);
    }
  }

  GroupViewModel buildGroupViewModel(Object arguments);
}
