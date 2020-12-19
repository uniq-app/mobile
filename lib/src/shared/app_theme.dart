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
    primaryColor: Colors.deepPurple[300],
    primaryColorLight: Colors.deepPurple[400],
    accentColor: Colors.grey[700],
    iconTheme: IconThemeData(color: Colors.deepOrange),
    buttonColor: Colors.grey[900],

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.deepPurple[500],
      selectedItemColor: Colors.amber[300],
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.black, elevation: 0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber[200],
    ),
    // Define the default font family.
    fontFamily: 'Lato',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(),
  );
}
