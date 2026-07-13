import 'dart:ui';

import 'package:flutter/material.dart';

class CtxMenu extends StatelessWidget {
  const CtxMenu({super.key, required this.buttons, required this.builder});
  final List<Widget> buttons;
  final MenuAnchorChildBuilder builder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    MenuController controller = MenuController();

    final Color menuBackground = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.7),
      colorScheme.surface,
    );

    const double radius = 8;

    return Listener(
      onPointerDown: (_) {
        if (controller.isOpen) controller.close();
      },
      child: GestureDetector(
        onSecondaryTapDown: (details) =>
            controller.open(position: details.localPosition),
        onLongPressStart: (details) =>
            controller.open(position: details.localPosition),
        child: MenuAnchor(
          style: MenuStyle(
            mouseCursor: WidgetStateProperty.resolveWith((states) {
              return SystemMouseCursors.basic;
            }),
            padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
          ),
          controller: controller,
          menuChildren: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(radius),
                  decoration: BoxDecoration(
                    color: menuBackground.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buttons,
                  ),
                ),
              ),
            ),
          ],
          builder: builder,
        ),
      ),
    );
  }
}
