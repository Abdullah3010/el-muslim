import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newRawText = newValue.text.replaceAll(' ', '');
    // +963 945 234 567 for Syria.

    List<String> newStrignList = newRawText.split('');

    if (newStrignList.length > 3) {
      newStrignList.insert(3, ' ');
    }
    if (newStrignList.length > 7) {
      newStrignList.insert(7, ' ');
    }

    int cursorPosition = newValue.selection.baseOffset;
    int formattedCursorPosition = cursorPosition;
    int spaceCount = newStrignList.where((char) => char == ' ').length;
    formattedCursorPosition += spaceCount;

    return TextEditingValue(
      text: newStrignList.join(),
      selection: TextSelection.collapsed(offset: formattedCursorPosition.clamp(0, newStrignList.length)),
    );
  }
}
