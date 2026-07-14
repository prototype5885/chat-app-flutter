import 'dart:developer';

import 'package:chat_app_flutter/services/date.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets_stateless/avatar.dart';
import 'package:chat_app_flutter/widgets_stateless/message_attachments.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.msg, required this.small});
  final MessageResponse msg;
  final bool small;

  void _onPressed() {
    log("Avatar pressed of user ID ${msg.senderId}");
  }

  @override
  Widget build(BuildContext context) {
    final double padding = small ? 0.0 : 4.0;
    final ValueNotifier<bool> isHoveringOvername = ValueNotifier(false);
    final ValueNotifier<bool> isHovering = ValueNotifier(false);

    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: InkWell(
        onTap: () {},
        onHover: (value) => isHovering.value = value,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        mouseCursor: SystemMouseCursors.basic,
        child: Stack(
          children: [
            // the date that shows on the left side of small format messages on hover
            if (small)
              ValueListenableBuilder(
                valueListenable: isHovering,
                builder: (context, value, child) {
                  return Visibility(
                    visible: value,
                    child: SizedBox(
                      width: 58,
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          getShortDate(msg.id),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: padding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (small)
                    SizedBox(width: 40, height: small ? 24 : 40)
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
                        if (small)
                          const SizedBox.shrink()
                        else
                          Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => isHoveringOvername.value = true,
                                onExit: (_) => isHoveringOvername.value = false,
                                child: GestureDetector(
                                  onTap: () {
                                    log(
                                      'User name pressed for ID: ${msg.senderId}',
                                    );
                                  },
                                  child: ValueListenableBuilder(
                                    valueListenable: isHoveringOvername,
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
                                  getDate(msg.id),
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
          ],
        ),
      ),
    );
  }
}
