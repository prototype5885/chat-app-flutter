import 'dart:developer';

import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../snowflake.dart' as snowflake;

class Message extends StatefulWidget {
  final String id;
  final String userID;
  final String name;
  final String pic;
  final String msg;
  final bool sameUser;

  const Message({
    super.key,
    required this.id,
    required this.userID,
    required this.name,
    required this.pic,
    required this.msg,
    this.sameUser = false,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isHoveringName = false;
  bool isHoveringMessage = false;
  late double padding = widget.sameUser ? 0.0 : 4.0;

  void pressed() {
    log("Avatar pressed for ID: ${widget.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHoveringMessage = true),
        onExit: (event) => setState(() => isHoveringMessage = false),
        child: Container(
          color: isHoveringMessage
              ? Color.fromRGBO(255, 255, 255, 0.05)
              : Colors.transparent,
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
                    pic: widget.pic,
                    name: widget.name,
                    pressed: pressed,
                  ),

                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.sameUser)
                        SizedBox.shrink()
                      else
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                log(
                                  'User name pressed for ID: ${widget.userID}',
                                );
                              },
                              child: MouseRegion(
                                onEnter: (event) =>
                                    setState(() => isHoveringName = true),
                                onExit: (event) =>
                                    setState(() => isHoveringName = false),
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: isHoveringName
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                snowflake.extractDate(
                                  widget.id,
                                  snowflake.SnowflakeDateFormat.long,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withAlpha(128),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SelectableText(
                        widget.msg,
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
