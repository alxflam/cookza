import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/mobile/qr_scanner.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/groups/abstract_group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cookza/localization/keys.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const DELETE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Delete, Icons.delete);
  static const EDIT =
      const PopupMenuButtonChoices._internal(Keys.Ui_Edit, Icons.edit);
  static const ADD_USER =
      const PopupMenuButtonChoices._internal(Keys.Ui_Adduser, Icons.person_add);
  static const LEAVE = const PopupMenuButtonChoices._internal(
      Keys.Ui_Leavegroup, Icons.exit_to_app);
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
                            Text(PopupMenuButtonChoices.EDIT.toString())
                          ],
                        ),
                        value: PopupMenuButtonChoices.EDIT,
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.ADD_USER.icon),
                            Text(PopupMenuButtonChoices.ADD_USER.toString())
                          ],
                        ),
                        value: PopupMenuButtonChoices.ADD_USER,
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
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.LEAVE.icon),
                            Text(PopupMenuButtonChoices.LEAVE.toString())
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
                        child: Text(translate(Keys.Ui_Singlemember)),
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
                          title:
                              Text(user.name == null ? 'unknown' : user.name),
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
              title: Text(translate(Keys.Ui_Editgroup)),
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
                                    hintText: translate(Keys.Ui_Groupname)),
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
          title: Text(translate(Keys.Ui_Delete)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  translate(
                    Keys.Ui_Confirmdelete,
                    args: {"0": model.name},
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                translate(Keys.Ui_Cancel),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                translate(Keys.Ui_Delete),
              ),
              color: Colors.red,
              onPressed: () async {
                try {
                  await model.delete();
                } catch (e) {
                  // TODO: exception may occur if group has mor members!!
                  // TODO: anyways group vanished after other member left group...why?
                }
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
      model.addUser(scanResult.id, scanResult.name);
    }
  }

  void _leaveGroup(BuildContext context, GroupViewModel model) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate(Keys.Ui_Delete)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  translate(
                    Keys.Ui_Confirmleave,
                    args: {"0": model.name},
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                translate(Keys.Ui_Cancel),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                translate(Keys.Ui_Leavegroup),
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
