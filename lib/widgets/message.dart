import 'dart:developer';

import 'package:chat_app_flutter/services/globals.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets_stateless/avatar.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final MessageResponse msg;
  final bool sameUser = false;

  const Message({super.key, required this.msg});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isHoveringName = false;
  bool isHoveringMessage = false;
  late double padding = widget.sameUser ? 0.0 : 4.0;

  void pressed() {
    log("Avatar pressed for ID: ${widget.msg.id}");
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHoveringMessage = true),
        onExit: (event) => setState(() => isHoveringMessage = false),
        child: Container(
          color: isHoveringMessage ? getHoverColor(isDark) : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.sameUser)
                  SizedBox(width: 40, height: widget.sameUser ? 24 : 40)
                else
                  Avatar(
                    size: 40,
                    pic: widget.msg.picture,
                    name: widget.msg.displayName,
                    pressed: pressed,
                  ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.sameUser)
                        const SizedBox.shrink()
                      else
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                log(
                                  'User name pressed for ID: ${widget.msg.senderId}',
                                );
                              },
                              child: MouseRegion(
                                onEnter: (event) =>
                                    setState(() => isHoveringName = true),
                                onExit: (event) =>
                                    setState(() => isHoveringName = false),
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  widget.msg.displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: isHoveringName
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            // padding: const EdgeInsets.only(left: 8.0),
                            // child: Text(
                            //   date.getLongDate(widget.msg.id),
                            //   style: TextStyle(
                            //     fontSize: 11,
                            //     color: Colors.white.withAlpha(128),
                            //   ),
                            // ),
                            // ),
                          ],
                        ),
                      SelectableText(
                        widget.msg.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
