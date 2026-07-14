import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServerBase extends StatefulWidget {
  final int id;
  final String name;
  final Widget? icon;
  final String? pic;
  final bool selected;
  final Function(int) onClicked;

  const ServerBase({
    super.key,
    required this.id,
    required this.name,
    this.icon,
    this.pic,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = widget.selected || _isHovering;

    const animationLength = 150;

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
          child: Stack(
            children: [
              if (widget.id != -1) _leftIndicator(), // -1 is add button
              Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: animationLength),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(end: isActive ? size / 3 : size / 2),
                  builder: (context, animatedRadius, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(animatedRadius),
                      child: AnimatedContainer(
                        width: size,
                        height: size,
                        duration: const Duration(milliseconds: animationLength),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainer,
                        ),
                        child: widget.pic != null ? _picture() : _noPicture(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _picture() {
    return CachedNetworkImage(
      imageUrl: backend
          .replace(
            path: "/avatars/${widget.pic}",
            queryParameters: {'size': '96'},
          )
          .toString(),
      httpHeaders: !kIsWeb ? getTokenCookieHeader() : null,
      fit: BoxFit.cover,
      errorWidget: (context, error, stackTrace) {
        return _noPicture();
      },
    );
  }

  Widget _noPicture() {
    return Center(
      child: Text(
        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: size / 2.75,
        ),
      ),
    );
  }

  Widget _leftIndicator() {
    double height = 8;
    if (widget.selected) {
      height = 40;
    } else if (_isHovering) {
      height = 20;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        width: widget.selected || _isHovering ? 4 : 0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
      ),
    );
  }
}
