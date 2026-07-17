import 'dart:developer';

import 'package:chat_app_flutter/services/date.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/clickable_text.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:chat_app_flutter/widgets/message_attachments.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({super.key, required this.msg, required this.small});
  final MessageResponse msg;
  final bool small;

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isHovering = false;

  void _onPressed() {
    log("Avatar pressed of user ID ${widget.msg.senderId}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.small ? 0 : 4),
      child: InkWell(
        onTap: () {},
        onHover: (value) => setState(() {
          isHovering = value;
        }),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        mouseCursor: SystemMouseCursors.basic,
        child: Stack(
          children: [
            // the date that shows on the left side of small format messages on hover
            if (widget.small)
              Visibility(visible: isHovering, child: _smallDate()),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: widget.small ? 0 : 4,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // either show avatar or not depending on if normal or small format message
                  // but if there is no avatar it will take up same amount of width
                  _avatarSlot(),

                  const SizedBox(width: 12.0),

                  // username, date
                  // text message
                  // attachment
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.small) _nameWithDate(context),
                        ..._chatMessage(),
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

  Widget _nameWithDate(BuildContext context) {
    return Row(
      children: [
        ClickableText(
          onClicked: () {
            log('User name pressed for ID: ${widget.msg.senderId}');
          },
          text: widget.msg.displayName,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            getDate(context, widget.msg.id),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smallDate() {
    return SizedBox(
      width: 58,
      height: 24,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          getShortDate(widget.msg.id),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  List<Widget> _chatMessage() {
    return [
      SelectableText(
        widget.msg.message,
        style: const TextStyle(fontSize: 15),
        contextMenuBuilder: null,
      ),

      if (widget.msg.attachments != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Attachments(attachments: widget.msg.attachments!),
        ),
    ];
  }

  Widget _avatarSlot() {
    if (!widget.small) {
      return Avatar(
        size: 40,
        pic: widget.msg.picture,
        name: widget.msg.displayName,
        pressed: _onPressed,
      );
    } else {
      return const SizedBox(width: 40, height: 24);
    }
  }
}
