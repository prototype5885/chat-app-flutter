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
  final ScrollController scrollController = ScrollController();
  bool reachedTop = false;
  bool requestInProgress = false;

  @override
  void initState() {
    if (!state.demo.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ws.events.on(
          "MessageCreated",
          (String data) => addMessage(
            MessageModel.fromJson(jsonDecode(data) as Map<String, dynamic>),
          ),
        );
      });
      messageListLoaded = fetchMessages("");
    } else {
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
    }
    scrollController.addListener(scrolled);
    super.initState();
  }

  @override
  void dispose() {
    if (!state.demo.value) {
      ws.events.off(type: "MessageCreated");
    }

    scrollController.removeListener(scrolled);
    super.dispose();
  }

  Future<void> fetchMessages(String messageID) async {
    if (reachedTop || requestInProgress) {
      return;
    }

    requestInProgress = true;

    if (widget.channelID.isEmpty) {
      log("Channel ID is empty, cannot request messages");
      return;
    }

    var queryParameters = {"channelID": widget.channelID};

    if (messageID.isNotEmpty) {
      queryParameters.addAll({"messageID": messageID});
    }

    log("Fetching messages for channel ID ${widget.channelID}...");
    final response = await dioClient.dio.get(
      '/api/message/fetch',
      queryParameters: queryParameters,
    );

    final List<dynamic> rawList = jsonDecode(response.data);

    if (rawList.isEmpty) {
      log("No more messages to request");
      reachedTop = true;
    }

    for (var item in rawList) {
      addMessage(MessageModel.fromJson(item));
    }

    requestInProgress = false;
  }

  void scrolled() async {
    final double distance =
        scrollController.position.maxScrollExtent -
        scrollController.position.pixels;

    if (distance >= 251.0) {
      return;
    }

    fetchMessages(messageList.last.id);
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
      // while (messageList.length > 50) {
      //   messageList.removeLast();
      // }
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
                controller: scrollController,
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
