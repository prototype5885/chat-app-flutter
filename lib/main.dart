import 'package:chat_app_flutter/routes/home.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  await setupCookieJar();
  await setupDioClient();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const useMaterial3 = true;
    const seedColor = Colors.blue;

    final lightTheme = ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );

    // dark theme
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      surface: const Color.fromRGBO(51, 51, 57, 1),
      surfaceContainerLowest: const Color.fromRGBO(44, 45, 49, 1),
      primaryContainer: const Color.fromRGBO(89, 103, 239, 1),
      surfaceContainer: const Color.fromRGBO(58, 58, 64, 1),
      brightness: Brightness.dark,
    );

    final darkTooltipTheme = TooltipThemeData(
      decoration: BoxDecoration(
        color: darkColorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      preferBelow: false,
    );

    final darkTheme = ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: darkColorScheme,
      tooltipTheme: darkTooltipTheme,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('hu')],
      locale: const Locale('en'),
      home: const Home(),
    );
  }
}
