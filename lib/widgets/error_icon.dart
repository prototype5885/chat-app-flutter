import 'package:flutter/material.dart';

class ErrorIcon extends StatelessWidget {
  final String text;

  const ErrorIcon({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 32, color: Colors.red),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
