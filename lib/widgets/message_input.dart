import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dio_client.dart';

class MessageInput extends StatefulWidget {
  final String channelID;

  const MessageInput({super.key, required this.channelID});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  static const double borderRadius = 8;
  late final TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final String message = controller.text.trim();

    if (message.isEmpty) {
      setState(() {
        controller.clear();
      });

      return;
    }

    if (widget.channelID.isEmpty) {
      log("Channel ID is empty, cannot send message");
      return;
    }

    var resp = await dioClient.dio.post(
      '/api/message/create',
      data: {'message': message, 'channelID': widget.channelID},
    );

    if (resp.statusCode == 200) {
      setState(() {
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Focus(
        child: KeyboardListener(
          focusNode: focusNode,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter) {
                if (HardwareKeyboard.instance.isShiftPressed) {
                  controller.text += '\n';
                } else {
                  sendMessage();
                }
              }
            }
          },
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.none,
            autofocus: true,
            autocorrect: true,
            cursorColor: Colors.white,
            cursorWidth: 1,
            maxLines: 12,
            minLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 0.05),
              hoverColor: Colors.transparent,

              hintText: "Message #${widget.channelID}",
              hintStyle: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14.0,
              ),

              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.white70),
                onPressed: sendMessage,
              ),

              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.05),
                  width: 1,
                ),
              ),

              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
