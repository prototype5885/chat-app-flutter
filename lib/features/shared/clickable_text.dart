import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  const ClickableText({super.key, required this.text, required this.onClicked});
  final String text;
  final Function() onClicked;

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onClicked,
        child: Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            decoration: _hovering
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
