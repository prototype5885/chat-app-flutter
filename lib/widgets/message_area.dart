import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/top.dart';
import 'package:flutter/material.dart';

class MessageArea extends StatelessWidget {
  final String channelID;

  const MessageArea({super.key, required this.channelID});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Top(childWidget: Text(channelID)),
        Expanded(child: Center(child: Text("chat messages"))),
        MessageInput(channelID: channelID),
        Text("typing..."),
      ],
    );
  }
}
