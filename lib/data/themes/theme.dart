import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.9),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      toolbarTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: buildTextTheme(base.textTheme, Colors.black),
    colorScheme: base.colorScheme.copyWith(
      secondary: Colors.pink,
      onBackground: Colors.black,
      background: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.pink,
        side: BorderSide(color: Colors.pink),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Colors.pink,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: buildTextTheme(base.textTheme, Colors.white),
    colorScheme: base.colorScheme.copyWith(
      secondary: Colors.pink,
      onBackground: Colors.white,
      background: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.pink,
        side: BorderSide(color: Colors.pink),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink,
      foregroundColor: Colors.white,
    ),
  );
}

TextTheme buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    bodyLarge: base.bodyLarge!.copyWith(color: color),
    bodyMedium: base.bodyMedium!.copyWith(color: color),
    displayLarge: base.displayLarge!.copyWith(color: color),
    displayMedium: base.displayMedium!.copyWith(color: color),
    displaySmall: base.displaySmall!.copyWith(color: color),
    headlineMedium: base.headlineMedium!.copyWith(color: color),
    headlineSmall: base.headlineSmall!.copyWith(color: color),
    titleLarge: base.titleLarge!.copyWith(color: color),
    titleMedium: base.titleMedium!.copyWith(color: color),
    titleSmall: base.titleSmall!.copyWith(color: color),
    labelLarge: base.labelLarge!.copyWith(color: color),
    labelMedium: base.labelMedium!.copyWith(color: color),
    labelSmall: base.labelSmall!.copyWith(color: color),
  );
}