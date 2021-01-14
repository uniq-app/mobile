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
        headline1: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
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
    //Appbar text
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      //Board element title
      headline2: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      //Main text on the screen - like 'change your email' or 'login to uniq'
      headline3: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      //Board description
      bodyText1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      //Subtext on the screen - like 'search for inspiration'
      bodyText2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      button: TextStyle(
        color: Color(0xffB65DC7),
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
    ),
  );
}
