import 'package:flutter/material.dart';
/*
 * ThemeData Api
 * https://api.flutter.dev/flutter/material/ThemeData-class.html
 */

class AppTheme {
  //
  AppTheme._();

  static final ThemeData mainTheme = ThemeData(
    // Define the default brightness and colors.

    brightness: Brightness.dark,
    primaryColor: Color(0xffB65DC7),
    primaryColorLight: Colors.deepPurple[400],
    accentColor: Colors.grey[700],
    iconTheme: IconThemeData(color: Colors.deepOrange),
    buttonColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(fontSize: 16),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 8.0,
      backgroundColor: Colors.grey[800],
      selectedItemColor: Colors.white,
    ),
    //bottomAppBarTheme: BottomAppBarTheme(color: Colors.black, elevation: 0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber[200],
    ),
    // Define the default font family.
    fontFamily: 'Nunito',
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(),
  );
}
