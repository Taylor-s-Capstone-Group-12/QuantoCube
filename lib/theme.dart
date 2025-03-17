import 'package:flutter/material.dart';

class ProjectTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      iconTheme: const IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.fromSeed(
        surface: Colors.black,
        seedColor: const Color.fromARGB(255, 254, 89, 37),
        primary: const Color.fromARGB(255, 254, 89, 37),
        secondary: const Color.fromARGB(255, 27, 27, 27),
        error: Colors.red,
        brightness: Brightness.dark,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color.fromARGB(255, 254, 89, 37),
        textTheme: ButtonTextTheme.primary,
      ),
      fontFamily: 'Golos',
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Golos',
            bodyColor: Colors.white,
            displayColor: Colors.white,
            decorationColor: Colors.white,
          ),
    );
  }

  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      //contentPadding: const EdgeInsets.all(20),
      isDense: false,
      hintStyle: TextStyle(
        color: Colors.grey[500],
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderSide: BorderSide.none, // No outline when not focused
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .primary, // Primary color outline when focused
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(BuildContext context) {
    return InputDecorationTheme(
      //contentPadding: const EdgeInsets.all(20),
      isDense: false,
      hintStyle: TextStyle(
        color: Colors.grey[500],
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderSide: BorderSide.none, // No outline when not focused
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .primary, // Primary color outline when focused
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
