import 'package:flutter/material.dart';

final ThemeData projectTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    surface: const Color(0xFF121212),
    seedColor: const Color.fromARGB(255, 254, 89, 37),
    primary: const Color.fromARGB(255, 254, 89, 37),
    secondary: const Color.fromARGB(255, 27, 27, 27),
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
