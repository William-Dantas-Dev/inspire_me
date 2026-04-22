import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor: Colors.black,

  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
  ),

  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
    ),
  ),
);