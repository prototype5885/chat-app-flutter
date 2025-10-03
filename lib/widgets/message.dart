import 'dart:developer';

import 'package:chat_app_flutter/macros.dart' as macros;
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String id;
  final String userID;
  final String name;
  final String pic;
  final String msg;

  const Message({
    super.key,
    required this.id,
    required this.userID,
    required this.name,
    required this.pic,
    required this.msg,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isHoveringName = false;
  bool isHoveringMessage = false;

  void pressed() {
    log("Avatar pressed for ID: ${widget.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHoveringMessage = true),
        onExit: (event) => setState(() => isHoveringMessage = false),
        child: Container(
          color: isHoveringMessage
              ? Color.fromRGBO(255, 255, 255, 0.05)
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 0.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              log('User name pressed for ID: ${widget.userID}');
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
                              macros.extractDate(
                                widget.id,
                                macros.SnowflakeDateFormat.long,
                              ),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withAlpha(128),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
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
