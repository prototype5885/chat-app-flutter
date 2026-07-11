import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/material.dart';

class Channel extends StatefulWidget {
  const Channel({
    super.key,
    required this.id,
    required this.name,
    required this.selected,
    required this.onClicked,
  });

  final int id;
  final String name;
  final bool selected;
  final Function(int) onClicked;

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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color? backgroundColor = isHovering ? getHoverColor(isDark) : null;

    backgroundColor = widget.selected
        ? getSelectedColor(isDark)
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(widget.name),
            ),
          ),
        ),
      ),
    );
  }
}
