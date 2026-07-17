import 'package:flutter/material.dart';

enum CtxMenuButtonVariant { white, red }

class CtxMenuButton extends StatelessWidget {
  const CtxMenuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.type = CtxMenuButtonVariant.white,
  });
  final String label;
  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final CtxMenuButtonVariant type;

  bool get _isRed => type == CtxMenuButtonVariant.red;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color hoverBackground = _isRed
        ? Colors.red
        : colorScheme.primaryContainer;
    final Color idleForeground = _isRed ? Colors.redAccent : Colors.white;

    return MenuItemButton(
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: Duration.zero,
        mouseCursor: WidgetStateProperty.resolveWith((states) {
          return SystemMouseCursors.click;
        }),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        iconColor: WidgetStateProperty.resolveWith((states) {
          final hovered = states.contains(WidgetState.hovered);
          if (_isRed) {
            return hovered ? Colors.white : Colors.redAccent;
          }
          return Colors.white;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.hovered)) return Colors.transparent;
          return hoverBackground;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final hovered = states.contains(WidgetState.hovered);
          if (_isRed) {
            return hovered ? Colors.white : idleForeground;
          }
          return idleForeground;
        }),
      ),
      child: Text(label),
    );
  }
}

Widget ctxMenuDivier() {
  return const Divider(height: 8);
}
