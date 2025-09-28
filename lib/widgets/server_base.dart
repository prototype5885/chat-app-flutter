import 'package:flutter/material.dart';

import '../globals.dart';
import '../macros.dart';

class ServerBase extends StatefulWidget {
  final String id;
  final String name;
  final String pic;
  final bool selected;
  final Function(String) onClicked;

  const ServerBase({
    super.key,
    required this.id,
    required this.name,
    required this.pic,
    required this.selected,
    required this.onClicked,
  });

  @override
  State<ServerBase> createState() => _ServerBaseState();
}

class _ServerBaseState extends State<ServerBase> {
  static const double size = 48;
  bool _isHovering = false;

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
    final double targetRadius = widget.selected || _isHovering
        ? size / 3
        : size / 2;

    final Color backgroundColor = widget.selected || _isHovering
        ? Colors.blue
        : Colors.white.withAlpha(18);

    return GestureDetector(
      onTap: () {
        widget.onClicked(widget.id);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          height: 56,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(targetRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(targetRadius),
                child: widget.pic.isNotEmpty
                    ? Image.network(
                        '$backendHttpAddress/cdn/avatars/${widget.pic}',
                        fit: BoxFit.cover,
                        cacheWidth: optimizeImageCache(size, context),
                        cacheHeight: optimizeImageCache(size, context),
                        width: size,
                        height: size,
                        errorBuilder: (context, error, stackTrace) {
                          return _noPicture();
                        },
                      )
                    : _noPicture(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noPicture() {
    if (widget.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Text(
        widget.name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: size / 3,
        ),
      ),
    );
  }
}
