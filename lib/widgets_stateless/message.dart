import 'dart:developer';

import 'package:chat_app_flutter/services/date.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets_stateless/avatar.dart';
import 'package:chat_app_flutter/widgets_stateless/context_menu.dart';
import 'package:chat_app_flutter/widgets_stateless/context_menu_button.dart';
import 'package:chat_app_flutter/widgets_stateless/message_attachments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.msg});
  final MessageResponse msg;
  final bool sameUser = false;

  void _onPressed() {
    log("Avatar pressed of user ID ${msg.senderId}");
  }

  void _onEdit() {
    log("Edit message ID ${msg.id}");
  }

  Future<void> _onCopyMessage() async {
    log("Copy message ID ${msg.id}");
    await Clipboard.setData(ClipboardData(text: msg.message));
  }

  Future<void> _onReply() async {
    log("Reply to message ID ${msg.id}");
  }

  Future<void> _onDelete() async {
    log("Delete message ID ${msg.id}");
  }

  Future<void> _onCopyId() async {
    log("Copy ID of message ID ${msg.id}");
    await Clipboard.setData(ClipboardData(text: msg.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final double padding = sameUser ? 0.0 : 4.0;
    final ValueNotifier<bool> isHovering = ValueNotifier(false);

    return CtxMenu(
      buttons: _contextMenuButtons(),
      builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.only(top: padding, bottom: padding),
          child: InkWell(
            onTap: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: padding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sameUser)
                    SizedBox(width: 40, height: sameUser ? 24 : 40)
                  else
                    Avatar(
                      size: 40,
                      pic: msg.picture,
                      name: msg.displayName,
                      pressed: _onPressed,
                    ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sameUser)
                          const SizedBox.shrink()
                        else
                          Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => isHovering.value = true,
                                onExit: (_) => isHovering.value = false,
                                child: GestureDetector(
                                  onTap: () {
                                    log(
                                      'User name pressed for ID: ${msg.senderId}',
                                    );
                                  },
                                  child: ValueListenableBuilder(
                                    valueListenable: isHovering,
                                    builder: (context, value, child) {
                                      return Text(
                                        msg.displayName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: value
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  getLongDate(msg.id),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SelectableText(
                          msg.message,
                          style: const TextStyle(fontSize: 14),
                          contextMenuBuilder: null,
                        ),

                        if (msg.attachments != null)
                          Padding(
                            padding: const EdgeInsetsGeometry.only(top: 8),
                            child: Attachments(attachments: msg.attachments!),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _contextMenuButtons() {
    return [
      CtxMenuButton(
        label: 'Edit Message',
        leadingIcon: const Icon(Icons.edit_outlined, size: 18),
        onPressed: () => _onEdit(),
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Copy Text',
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async => await _onCopyMessage(),
      ),
      CtxMenuButton(
        label: 'Reply',
        leadingIcon: const Icon(Icons.reply, size: 18),
        onPressed: () async => await _onReply(),
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Delete Message',
        leadingIcon: const Icon(Icons.delete_outline, size: 18),
        onPressed: () async => await _onDelete(),
        type: CtxMenuButtonVariant.red,
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Copy Message ID',
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () => _onCopyId(),
      ),
    ];
  }
}
