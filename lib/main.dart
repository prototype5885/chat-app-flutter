import 'package:chat_app_flutter/pages/start.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const _darkBackground = Color.fromRGBO(66, 68, 75, 1);
const FlexScheme _theme = FlexScheme.shadBlue;

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
      theme: FlexThemeData.light(scheme: _theme),
      darkTheme: FlexThemeData.dark(
        scheme: _theme,
        scaffoldBackground: _darkBackground,
      ),
      home: Start(),
    );
  }
}
