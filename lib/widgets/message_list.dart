import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/date.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/session.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/context_menu.dart';
import 'package:chat_app_flutter/widgets/context_menu_button.dart';
import 'package:chat_app_flutter/widgets/message.dart';
import 'package:chat_app_flutter/widgets/message_input.dart';
import 'package:chat_app_flutter/widgets/users_typing.dart';
import 'package:chat_app_flutter/widgets/top.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

sealed class ChatRow {}

class MessageRow extends ChatRow {
  final MessageResponse msg;
  final bool small;
  MessageRow(this.msg, {required this.small});
}

class DateDividerRow extends ChatRow {
  final int id;
  DateDividerRow(this.id);
}

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
  List<ChatRow> _rows = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen for new messages
      events.on(SseEvent.createMessage, (String data) {
        final message = MessageResponse.fromJson(jsonDecode(data));
        _setMessages([..._messageList, message]);
      });

      // listen for message edits
      events.on(SseEvent.editMessage, (String data) {
        final editedMessage = MessageEditResponse.fromJson(jsonDecode(data));

        for (int i = 0; i < _messageList.length; i++) {
          if (_messageList[i].id == editedMessage.id) {
            setState(() {
              _messageList[i].message = editedMessage.message;
              _messageList[i].edited = editedMessage.edited;
            });
            return;
          }
        }

        log(
          'Tried to edit message ID ${editedMessage.id} but it was not found in the list',
        );
        // TODO popup
      });

      // listen for message deletions
      events.on(SseEvent.deleteMessage, (String data) {
        final messageId = int.parse(data);

        final updatedList = _messageList
            .where((msg) => msg.id != messageId)
            .toList();
        _setMessages(updatedList);
      });
    });

    _messageListLoaded = _fetchMessages();
    super.initState();
  }

  @override
  void dispose() {
    events.off(type: SseEvent.createMessage);
    events.off(type: SseEvent.editMessage);
    events.off(type: SseEvent.deleteMessage);
    super.dispose();
    log('Disposed message_list of channel ID ${widget.channel.id}');
  }

  void _setMessages(List<MessageResponse> newList) {
    setState(() {
      _messageList = newList;
      if (!state.simpleMessages.value) _rows = _buildRows(_messageList);
    });
  }

  List<ChatRow> _buildRows(List<MessageResponse> messages) {
    final rows = <ChatRow>[];

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final prev = i > 0 ? messages[i - 1] : null;

      final isNewDay = prev == null || !isSameDay(prev.id, msg.id);
      if (isNewDay) {
        rows.add(DateDividerRow(msg.id));
      }

      final sameUser = prev != null && prev.senderId == msg.senderId;

      final olderThanFiveMins = prev != null
          ? isOlderThanFiveMins(prev.id, msg.id)
          : false;

      rows.add(
        MessageRow(msg, small: sameUser && !isNewDay && !olderThanFiveMins),
      );
    }

    return rows;
  }

  Future<void> _fetchMessages() async {
    if (!widget.isDemo) {
      final response = await dio.get(
        '/api/v1/channel/${widget.channel.id}/messages',
        options: Options(headers: {'Session-ID': widget.sessionId}),
      );
      final messages = (response.data as List<dynamic>).reversed
          .map(
            (jsonMap) =>
                MessageResponse.fromJson(jsonMap as Map<String, dynamic>),
          )
          .toList();
      _setMessages(messages);
    } else {
      final demoMessages = <MessageResponse>[
        for (int i = 0; i < 32; i++)
          MessageResponse(
            id: 0,
            senderId: 0,
            channelId: widget.channel.id,
            message: 'Message $i',
            displayName: 'Sample user',
          ),
      ];
      _setMessages(demoMessages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!state.mobile.value) Top(childWidget: Text(widget.channel.name)),
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
                  state.simpleMessages.value
                      ? ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _messageList.length,
                          itemBuilder: (context, index) {
                            final msg =
                                _messageList[_messageList.length - 1 - index];
                            return Message(msg: msg, small: false);
                          },
                        )
                      : ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _rows.length,
                          itemBuilder: (context, index) {
                            final row = _rows[_rows.length - 1 - index];
                            return switch (row) {
                              DateDividerRow(:final id) => _buildDayDivider(id),
                              MessageRow(:final msg, :final small) => CtxMenu(
                                buttons: _contextMenuButtons(msg),
                                builder: (context, controller, child) {
                                  return Message(msg: msg, small: small);
                                },
                              ),
                            };
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

  Widget _buildDayDivider(int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              getDayDate(context, id),
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  List<Widget> _contextMenuButtons(MessageResponse msg) {
    final owner = msg.senderId == widget.userId;
    final loc = AppLocalizations.of(context)!;

    return [
      if (owner)
        CtxMenuButton(
          label: loc.edit,
          leadingIcon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: () {
            log("Edit message ID ${msg.id}");
          },
        ),
      if (owner) ctxMenuDivier(),
      CtxMenuButton(
        label: loc.copy,
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy message ID ${msg.id}");
          await Clipboard.setData(ClipboardData(text: msg.message));
        },
      ),
      CtxMenuButton(
        label: loc.reply,
        leadingIcon: const Icon(Icons.reply, size: 18),
        onPressed: () async {
          log("Reply to message ID ${msg.id}");
        },
      ),
      if (owner) ctxMenuDivier(),
      if (owner)
        CtxMenuButton(
          label: loc.delete,
          leadingIcon: const Icon(Icons.delete_outline, size: 18),
          onPressed: () async {
            log("Requesting to delete message ID ${msg.id}");
            try {
              // TODO do a popup
              await dio.delete(
                "/api/v1/channel/${msg.channelId}/message/${msg.id}",
              );
            } catch (e) {
              // TODO
            }
          },
          type: CtxMenuButtonVariant.red,
        ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: loc.copyId,
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of message ID ${msg.id}");
          await Clipboard.setData(ClipboardData(text: msg.id.toString()));
        },
      ),
    ];
  }
}
