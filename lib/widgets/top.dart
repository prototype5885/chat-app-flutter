import 'package:flutter/material.dart';

class Top extends StatelessWidget {
  final Widget childWidget;

  const Top({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Center(child: childWidget),
    );
  }
}
