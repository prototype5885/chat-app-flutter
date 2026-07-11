import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/material.dart';

class Top extends StatelessWidget {
  const Top({super.key, required this.childWidget});
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(border: Border(bottom: defaultBorder)),
      child: Center(child: childWidget),
    );
  }
}
