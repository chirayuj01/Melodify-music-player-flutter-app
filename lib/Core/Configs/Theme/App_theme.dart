import 'package:flutter/material.dart';
import 'App_colors.dart';
class App_Theme{
  static final lightTheme=ThemeData(
    primaryColor: App_Colors.primary,
    scaffoldBackgroundColor: App_Colors.lightbackground,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: App_Colors.primary,
        textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
      )
    )

  );
  static final darkTheme=ThemeData(
      primaryColor: App_Colors.primary,
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.dark,
      fontFamily: 'Satoshi',
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: App_Colors.primary,
              textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          )
      )

  );
}