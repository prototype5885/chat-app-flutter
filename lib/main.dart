import 'package:chat_app_flutter/routes/home.dart';
import 'package:chat_app_flutter/routes/login.dart';
import 'package:chat_app_flutter/routes/registration.dart';
import 'package:chat_app_flutter/routes/chat.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  await setupDioClient();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,

      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/registration': (context) => const Registration(),
        '/chat': (context) => const Chat(),
      },
    );
  }
}
