import 'dart:developer';

import 'package:chat_app_flutter/services/date.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets_stateless/avatar.dart';
import 'package:chat_app_flutter/widgets_stateless/message_attachments.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.msg});
  final MessageResponse msg;
  final bool sameUser = false;

  void pressed() {
    log("Avatar pressed for ID: ${msg.id}");
  }

  @override
  Widget build(BuildContext context) {
    final double padding = sameUser ? 0.0 : 4.0;
    final ValueNotifier<bool> isHovering = ValueNotifier(false);

    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: InkWell(
        onTap: () {},
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: padding),
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
                  pressed: pressed,
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
  }
}
