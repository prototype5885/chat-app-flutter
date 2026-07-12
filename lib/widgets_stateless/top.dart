import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/material.dart';

class Top extends StatelessWidget {
  const Top({super.key, required this.childWidget});
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      decoration: BoxDecoration(
        border: Border(bottom: defaultBorder(colorScheme)),
      ),
      child: childWidget,
    );
  }
}
