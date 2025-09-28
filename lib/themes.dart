import 'package:flutter/material.dart';

const Color _discordBlue = Color(0xff5865F2);

const _discordBackground = Color.fromRGBO(66, 68, 75, 0.4);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _discordBlue,
  colorScheme: const ColorScheme.light(primary: _discordBlue),
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: _elevatedButtonTheme,
  appBarTheme: _appBarTheme,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _discordBlue,
  colorScheme: const ColorScheme.dark(
    primary: _discordBlue,
    secondary: _discordBlue,
    tertiary: Colors.red,
  ),
  scaffoldBackgroundColor: _discordBackground,
  elevatedButtonTheme: _elevatedButtonTheme,
  appBarTheme: _appBarTheme,
);

final _appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  centerTitle: true,
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: _discordBlue,
    foregroundColor: Colors.white,
    // textStyle: TextStyle(fontWeight: FontWeight.bold),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);
