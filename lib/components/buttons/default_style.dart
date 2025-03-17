import 'package:flutter/material.dart';

class DefaultButtonStyle {
  static ButtonStyle getStyle(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
