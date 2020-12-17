import 'package:flutter/material.dart';

/*
 * ThemeData Api
 * https://api.flutter.dev/flutter/material/ThemeData-class.html
 */

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    // Define the default brightness and colors.

    brightness: Brightness.dark,
    primaryColor: Colors.amber[200],
    accentColor: Colors.deepPurple[400],
    iconTheme: IconThemeData(color: Colors.deepOrange),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.deepPurple[700],
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.black, elevation: 0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber[200],
    ),
    // Define the default font family.
    fontFamily: 'Georgia',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(),
  );
}
