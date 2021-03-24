import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/json/user.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';

class ShareAccountScreenModel with ChangeNotifier {
  void refresh() {
    notifyListeners();
  }

  set userName(String value) {
    sl.get<SharedPreferencesProvider>().setUserName(value);
  }

  String get userName => sl.get<SharedPreferencesProvider>().getUserName();

  bool get hasName {
    return userName.isNotEmpty;
  }

  JsonUser get jsonUser {
    return JsonUser(
        id: sl.get<FirebaseProvider>().userUid,
        name: sl.get<SharedPreferencesProvider>().getUserName(),
        type: USER_TYPE.USER);
  }
}
