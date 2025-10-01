import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/top.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

class MessageArea extends StatelessWidget {
  final String channelID;

  const MessageArea({super.key, required this.channelID});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?!state.mobile.value ? Top(childWidget: Text(channelID)) : null,
        Expanded(child: Center(child: Text("chat messages"))),
        MessageInput(channelID: channelID),
        Text("typing..."),
      ],
    );
  }
}
