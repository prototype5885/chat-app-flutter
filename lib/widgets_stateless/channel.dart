import 'dart:developer';

import 'package:chat_app_flutter/widgets_stateless/context_menu.dart';
import 'package:chat_app_flutter/widgets_stateless/context_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return CtxMenu(
      buttons: _contextMenuButtons(),
      builder: (context, controller, child) {
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
      },
    );
  }

  List<Widget> _contextMenuButtons() {
    return [
      CtxMenuButton(
        label: 'Edit Channel',
        leadingIcon: const Icon(Icons.edit_outlined, size: 18),
        onPressed: () {
          log("Edit channel ID $id");
        },
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Delete Channel',
        leadingIcon: const Icon(Icons.delete_outline, size: 18),
        onPressed: () {
          log("Delete message ID $id");
        },
        type: CtxMenuButtonVariant.red,
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Copy Channel ID',
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of channel ID $id");
          await Clipboard.setData(ClipboardData(text: id.toString()));
        },
      ),
    ];
  }
}
