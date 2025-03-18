import 'package:flutter/widgets.dart';

class Utils {
  static String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (int i = 0; i < numWords; i++) {
      initials += names[i][0];
    }
    return initials;
  }

  static unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
