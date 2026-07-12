import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/channel.dart';
import 'package:chat_app_flutter/widgets/message_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets_stateless/top.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({
    super.key,
    required this.isDemo,
    required this.server,
    required this.sessionId,
    required this.userId,
  });
  final bool isDemo;
  final ServerSchema server;
  final int sessionId;
  final int userId;

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late Future<void> _channelListLoaded;
  late List<ChannelSchema> _channelList = [];
  ChannelSchema? currentChannel;

  @override
  void initState() {
    _channelListLoaded = fetchChannels();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchChannels() async {
    if (!widget.isDemo) {
      final response = await dio.get(
        '/api/v1/server/${widget.server.id}/channels',
        options: Options(headers: {'Session-ID': widget.sessionId}),
      );
      setState(() {
        _channelList = (response.data as List<dynamic>)
            .map(
              (jsonMap) =>
                  ChannelSchema.fromJson(jsonMap as Map<String, dynamic>),
            )
            .toList();
      });
    } else {
      setState(() {
        for (int i = 0; i < 5; i++) {
          _channelList.add(
            ChannelSchema(
              id: i,
              serverId: widget.server.id,
              name: 'Channel ${i + 1}',
            ),
          );
        }
      });
    }

    if (!state.mobile && _channelList.isNotEmpty) {
      selectChannel(_channelList.first.id);
    }
  }

  void selectChannel(int channelId) {
    for (int i = 0; i < _channelList.length; i++) {
      if (_channelList[i].id == channelId) {
        setState(() {
          currentChannel = _channelList[i];
        });
        log("Selected channel ID $channelId");
        break;
      }
    }

    // if mobile then show the chat on the screen
    if (state.mobile && currentChannel != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(currentChannel!.name)),
            body: SafeArea(
              child: MessageList(
                key: ValueKey(currentChannel!.id),
                isDemo: widget.isDemo,
                channel: currentChannel!,
                sessionId: widget.sessionId,
                userId: widget.userId,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: [
          // if on mobile make channels take up remaining of screen
          // as messages won't be displayed right from it
          state.mobile
              ? Expanded(
                  child: Container(
                    color: colorScheme.surfaceContainerLowest,
                    child: _channelListWidget(),
                  ),
                )
              : Container(
                  width: 240,
                  color: colorScheme.surfaceContainerLowest,
                  child: _channelListWidget(),
                ),

          // if on mobile then don't display messages
          if (!state.mobile && currentChannel != null)
            Expanded(
              child: MessageList(
                key: ValueKey(currentChannel),
                isDemo: widget.isDemo,
                channel: currentChannel!,
                sessionId: widget.sessionId,
                userId: widget.userId,
              ),
            ),
        ],
      ),
    );
  }

  Widget _channelListWidget() {
    return Column(
      children: [
        Top(childWidget: Center(child: Text(widget.server.name))),
        Expanded(
          child: FutureBuilder(
            future: _channelListLoaded,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                final error = asyncSnapshot.error;
                return Text(error.toString());
              }

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _channelList.length,
                    itemBuilder: (context, index) {
                      final channel = _channelList[index];
                      return Channel(
                        key: ValueKey(channel.id),
                        id: channel.id,
                        name: channel.name,
                        selected: channel.id == currentChannel?.id,
                        onClicked: selectChannel,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
