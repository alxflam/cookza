import 'package:flutter/material.dart';

class OnboardingModel with ChangeNotifier {
  bool _termsOfUse = false;
  bool _privacyStatement = false;

  bool get termsOfUse => this._termsOfUse;

  bool get privacyStatement => this._privacyStatement;

  bool get acceptedAll => termsOfUse && privacyStatement;

  set termsOfUse(bool value) {
    this._termsOfUse = value;
    notifyListeners();
  }

  set privacyStatement(bool value) {
    this._privacyStatement = value;
    notifyListeners();
  }
}
