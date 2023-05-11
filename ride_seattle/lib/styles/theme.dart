import 'package:flutter/material.dart';

class RideSeattleTheme {
  static ThemeData theme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue[900],
      primaryColorLight: Colors.blue,
      primaryColorDark: Colors.blue[800],
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.blue[50],
      dividerColor: Colors.grey[400],
      secondaryHeaderColor: Colors.orange,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.blue[900],
      hintColor: Colors.grey[400],
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      primaryTextTheme: const TextTheme(
        bodySmall: TextStyle(
          fontFamily: 'route',
          fontSize: 14,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'route',
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        bodySmall: TextStyle(
          fontFamily: 'route',
          fontSize: 14,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'route',
          fontSize: 20,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'route',
          fontSize: 30,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
        fontFamily: 'route',
        fontSize: 24,
      )),
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
    );
  }
}
