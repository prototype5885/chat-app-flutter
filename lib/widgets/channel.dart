import 'package:flutter/material.dart';

import '../globals.dart';

class Channel extends StatefulWidget {
  final String id;
  final String name;
  final bool selected;
  final Function(String) onClicked;

  const Channel({
    super.key,
    required this.id,
    required this.name,
    required this.selected,
    required this.onClicked,
  });

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isHovering ? hoverBG : Colors.transparent;
    backgroundColor = widget.selected
        ? Color.fromRGBO(255, 255, 255, 0.08)
        : backgroundColor;

    return GestureDetector(
      onTap: () {
        widget.onClicked(widget.id);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 36,
          child: Center(child: Text(widget.name)),
        ),
      ),
    );
  }
}
