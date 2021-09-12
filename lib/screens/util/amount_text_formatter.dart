import 'package:flutter/services.dart';

class AmountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int length = newValue.text.length;

    // don't display the initial '0.0' as this means extra effort for the user (needs to clear the default input before entering values)
    if (length == 0 || newValue.text == '0') {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    return TextEditingValue(
      text: newValue.text,
      selection: TextSelection.collapsed(offset: length),
    );
  }
}
