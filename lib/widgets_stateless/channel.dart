import 'package:flutter/material.dart';

class Channel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          onClicked(id);
        },
        selected: selected,
        selectedTileColor: colorScheme.surfaceContainer,
        splashColor: Colors.transparent,
        dense: true,
        horizontalTitleGap: 8,
        leading: Transform(
          transform: Matrix4.skewX(-0.2),
          child: const Icon(Icons.tag),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
