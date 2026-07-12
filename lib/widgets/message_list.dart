import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/session.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/message.dart';
import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/users_typing.dart';
import 'package:chat_app_flutter/widgets_stateless/top.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  bool hasScrolledInitially = false;

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
        scrollToEnd();
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

  void scrollToEnd() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    });
  }

  void scrollToEndInstant() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      setState(() {
        hasScrolledInitially = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

              if (asyncSnapshot.connectionState == ConnectionState.done &&
                  !hasScrolledInitially) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToEndInstant();
                });
              }

              return Visibility(
                visible: hasScrolledInitially,
                maintainState: true,
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _messageList.length,
                      itemBuilder: (context, index) {
                        return Message(msg: _messageList[index]);
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
                ),
              );
            },
          ),
        ),
        MessageInput(channel: widget.channel),
      ],
    );
  }
}
