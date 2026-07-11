import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServerBase extends StatefulWidget {
  final int id;
  final String name;
  final String? pic;
  final bool selected;
  final Function(int) onClicked;

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
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = widget.selected || _isHovering;

    final double targetRadius = isActive ? size / 3 : size / 2;

    final Color backgroundColor = isActive
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainer;

    final Color textColor = colorScheme.onSurface;

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
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: animationLength),
              curve: Curves.easeInOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(targetRadius),
              ),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: animationLength),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: targetRadius, end: targetRadius),
                builder: (context, animatedRadius, child) {
                  return widget.pic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(animatedRadius),
                          child: CachedNetworkImage(
                            imageUrl: backend
                                .replace(
                                  path: "/avatars/${widget.pic}",
                                  queryParameters: {'size': '96'},
                                )
                                .toString(),
                            httpHeaders: !kIsWeb
                                ? getTokenCookieHeader()
                                : null,
                            fit: BoxFit.cover,
                            width: size,
                            height: size,

                            errorWidget: (context, error, stackTrace) {
                              return _noPicture(textColor);
                            },
                          ),
                          // Image.network(
                          //   backend
                          //       .replace(
                          //         path: "/avatars/${widget.pic}",
                          //         queryParameters: {'size': '96'},
                          //       )
                          //       .toString(),
                          //   fit: BoxFit.cover,
                          //   // cacheWidth: optimizeImageCache(size, context),
                          //   // cacheHeight: optimizeImageCache(size, context),
                          //   width: size,
                          //   height: size,
                          //   errorBuilder: (context, error, stackTrace) {
                          //     return _noPicture(textColor);
                          //   },
                          // ),
                        )
                      : _noPicture(textColor);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noPicture(Color textColor) {
    if (widget.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Text(
        widget.name[0].toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: size / 3.5,
        ),
      ),
    );
  }
}
