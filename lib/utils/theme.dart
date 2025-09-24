import 'package:flutter/material.dart';

final light = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    hintStyle: TextStyle(color: Colors.grey),
    fillColor: Colors.white,
    prefixIconColor: Colors.grey,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionColor: Colors.blue.shade200,
    selectionHandleColor: Colors.blue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      textStyle: TextStyle(fontSize: 16, color: Colors.white),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.grey,
      textStyle: TextStyle(
        fontSize: 14,
        color: Colors.black,
        decoration: TextDecoration.underline,
      ),
    ),
  ),
);
