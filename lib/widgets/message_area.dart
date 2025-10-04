import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/widgets/message.dart';
import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/top.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/websocket.dart' as ws;

import '../dio_client.dart';
import '../macros.dart';
import 'delayed_loading_indicator.dart';

class MessageArea extends StatefulWidget {
  final String channelID;

  const MessageArea({super.key, required this.channelID});

  @override
  State<StatefulWidget> createState() => _MessageAreaState();
}

class _MessageAreaState extends State<MessageArea> {
  late Future<void> messageListLoaded;
  late List<MessageModel> messageList = [];

  @override
  void initState() {
    if (state.demo.value) {
      messageList = List.generate(50, (index) {
        final messageNumber = index + 1;
        return MessageModel(
          id: messageNumber.toString(),
          channelID: widget.channelID,
          userID: '0',
          message: "Message $messageNumber",
          user: UserModel(displayName: 'User name $messageNumber', picture: ''),
        );
      });
      messageListLoaded = Future.value();
    } else {
      messageListLoaded = fetchMessages();
    }
    super.initState();
  }

  @override
  void dispose() {
    ws.events.off(type: "MessageCreated");
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (widget.channelID == "") {
      return;
    }

    log("Fetching messages for channel ID ${widget.channelID}...");
    final response = await dioClient.dio.get(
      '/api/message/fetch',
      queryParameters: {"channelID": widget.channelID},
    );
    final List<dynamic> rawList = jsonDecode(response.data);
    for (var item in rawList) {
      addMessage(MessageModel.fromJson(item));
    }

    ws.events.on(
      "MessageCreated",
      (String data) => addMessage(
        MessageModel.fromJson(jsonDecode(data) as Map<String, dynamic>),
      ),
    );
  }

  void addMessage(MessageModel newMsg) {
    // insert in proper place depending on time
    int insertIndex = messageList.length;
    for (int i = 0; i < messageList.length; i++) {
      if (BigInt.parse(messageList[i].id) < BigInt.parse(newMsg.id)) {
        insertIndex = i;
        break;
      }
    }
    setState(() {
      messageList.insert(insertIndex, newMsg);
      while (messageList.length > 50) {
        messageList.removeLast();
      }
    });

    // format messages depending on if previous sender is same as new
    // setState(() {
    //   for (int i = 0; i < messageList.length; i++) {
    //     if (i - 1 >= 0) {
    //       if (messageList[i].userID == messageList[i - 1].userID) {
    //         messageList[i - 1] = messageList[i - 1].copyWith(sameUser: true);
    //       }
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?!state.mobile.value ? Top(childWidget: Text(widget.channelID)) : null,
        Expanded(
          child: FutureBuilder(
            future: messageListLoaded,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return DelayedLoadingIndicator();
              }

              if (asyncSnapshot.hasError) {
                return handleError(asyncSnapshot.error);
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  final msg = messageList[index];
                  return Message(
                    id: msg.id,
                    userID: msg.userID,
                    name: msg.user.displayName,
                    pic: msg.user.picture,
                    msg: msg.message,
                    sameUser: msg.sameUser,
                  );
                },
              );
            },
          ),
        ),
        MessageInput(channelID: widget.channelID),
        Text("typing..."),
      ],
    );
  }
}
