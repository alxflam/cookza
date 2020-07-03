import 'package:cookly/components/padded_qr_code.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ShareAccountScreen extends StatelessWidget {
  static final String id = 'shareAccount';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Ui_Shareaccount)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) {
              var editMode = false;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getUserNameField(editMode),
                          IconButton(
                            icon:
                                editMode ? Icon(Icons.check) : Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                editMode = !editMode;
                              });
                            },
                          )
                        ]),
                  );
                },
              );
            }),
            PaddedQRCode(sl.get<FirebaseProvider>().userUid, 400, 400)
          ],
        ),
      ),
    );
  }

  Widget _getUserNameField(bool editMode) {
    var userName = sl.get<SharedPreferencesProvider>().getUserName();
    if (editMode) {
      var controller = TextEditingController(text: userName);

      return Expanded(
        child: TextFormField(
          controller: controller,
          maxLines: 1,
          maxLength: 20,
          autofocus: true,
          onChanged: (value) {
            if (value.length > 1) {
              sl.get<SharedPreferencesProvider>().setUserName(value);
            }
          },
          decoration: InputDecoration(hintText: 'Your external user name'),
        ),
      );
    }
    return Text(userName);
  }
}
