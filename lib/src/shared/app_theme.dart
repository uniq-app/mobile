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
    primaryColorLight: Color(0xff7E408A),
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
      backgroundColor: Color(0xff7E408A),
    ),
    // Define the default font family.
    fontFamily: 'Lato',
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w200,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    ),
  );
}
