import 'package:chat_app_flutter/pages/welcome.dart';
import 'package:chat_app_flutter/themes.dart';
import 'package:flutter/material.dart';

void main() {
  // const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
  // print('wasm: $isRunningWithWasm');

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      themeMode: ThemeMode.dark,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: WelcomePage(),
    );
  }
}
