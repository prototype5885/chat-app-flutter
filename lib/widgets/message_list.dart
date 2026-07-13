import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/session.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets_stateless/context_menu.dart';
import 'package:chat_app_flutter/widgets_stateless/context_menu_button.dart';
import 'package:chat_app_flutter/widgets_stateless/message.dart';
import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/users_typing.dart';
import 'package:chat_app_flutter/widgets_stateless/top.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.isDemo,
    required this.channel,
    required this.sessionId,
    required this.userId,
  });
  final bool isDemo;
  final ChannelSchema channel;
  final int sessionId;
  final int userId;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late Future<void> _messageListLoaded;
  List<MessageResponse> _messageList = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      events.on(SseEvent.createMessage, (String data) {
        setState(() {
          final message = MessageResponse.fromJson(
            jsonDecode(data) as Map<String, dynamic>,
          );
          _messageList.add(message);
        });
      });
    });

    _messageListLoaded = _fetchMessages();
    super.initState();
  }

  @override
  void dispose() {
    events.off(type: SseEvent.createMessage);
    super.dispose();
    log('Disposed message_list of channel ID ${widget.channel.id}');
  }

  Future<void> _fetchMessages() async {
    if (!widget.isDemo) {
      final response = await dio.get(
        '/api/v1/channel/${widget.channel.id}/messages',
        options: Options(headers: {'Session-ID': widget.sessionId}),
      );
      setState(() {
        _messageList = (response.data as List<dynamic>).reversed
            .map(
              (jsonMap) =>
                  MessageResponse.fromJson(jsonMap as Map<String, dynamic>),
            )
            .toList();
      });
    } else {
      setState(() {
        for (int i = 0; i < 32; i++) {
          _messageList.add(
            MessageResponse(
              id: 0,
              senderId: 0,
              channelId: widget.channel.id,
              message: 'Message $i',
              displayName: 'Sample user',
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!state.mobile) Top(childWidget: Text(widget.channel.name)),
        Expanded(
          child: FutureBuilder(
            future: _messageListLoaded,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                final error = asyncSnapshot.error;
                return Text(error.toString());
              }

              return Stack(
                children: [
                  ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _messageList.length,
                    itemBuilder: (context, index) {
                      final msg = _messageList[_messageList.length - 1 - index];
                      return CtxMenu(
                        buttons: _contextMenuButtons(msg),
                        builder: (context, controller, child) {
                          return Message(msg: msg);
                        },
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: UsersTyping(
                      userId: widget.userId,
                      isAtBottom: false,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        MessageInput(channel: widget.channel),
      ],
    );
  }

  List<Widget> _contextMenuButtons(MessageResponse msg) {
    final owner = msg.senderId == widget.userId;

    return [
      if (owner)
        CtxMenuButton(
          label: 'Edit Message',
          leadingIcon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: () {
            log("Edit message ID ${msg.id}");
          },
        ),
      if (owner) ctxMenuDivier(),
      CtxMenuButton(
        label: 'Copy Text',
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy message ID ${msg.id}");
          await Clipboard.setData(ClipboardData(text: msg.message));
        },
      ),
      CtxMenuButton(
        label: 'Reply',
        leadingIcon: const Icon(Icons.reply, size: 18),
        onPressed: () async {
          log("Reply to message ID ${msg.id}");
        },
      ),
      if (owner) ctxMenuDivier(),
      if (owner)
        CtxMenuButton(
          label: 'Delete Message',
          leadingIcon: const Icon(Icons.delete_outline, size: 18),
          onPressed: () async {
            log("Delete message ID ${msg.id}");
          },
          type: CtxMenuButtonVariant.red,
        ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: 'Copy Message ID',
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of message ID ${msg.id}");
          await Clipboard.setData(ClipboardData(text: msg.id.toString()));
        },
      ),
    ];
  }
}
