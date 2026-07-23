import 'package:flutter/material.dart';

class ButtonList extends StatelessWidget {
  const ButtonList({
    super.key,
    this.selected = false,
    this.horizontalTitleGap,
    this.leading,
    this.title,
    this.titleText,
    required this.onClicked,
  });
  final bool selected;
  final double? horizontalTitleGap;
  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Function onClicked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => onClicked(),
        selected: selected,
        selectedTileColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.onSurface,
        dense: true,
        horizontalTitleGap: horizontalTitleGap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: leading,
        title: title != null
            ? title!
            : Text(
                titleText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
