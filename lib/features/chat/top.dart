import 'package:flutter/material.dart';

class Top extends StatelessWidget {
  const Top({super.key, required this.childWidget});
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      child: childWidget,
    );
  }
}
