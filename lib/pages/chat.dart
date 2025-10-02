import 'dart:developer';
import 'package:chat_app_flutter/widgets/channel_list.dart';
import 'package:chat_app_flutter/widgets/message_area.dart';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

import '../dio_client.dart';
import '../websocket.dart' as ws;
import '../widgets/delayed_loading_indicator.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with AutomaticKeepAliveClientMixin {
  late Future<void> loaded;

  @override
  void initState() {
    if (!state.demo.value) {
      loaded = (() async {
        log("Fetching session ID...");
        await dioClient.dio.get('/api/auth/newSession');

        await ws.connect();
      })();
    } else {
      loaded = Future.value();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (!state.demo.value) {
      ws.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: loaded,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: DelayedLoadingIndicator());
          // } else if (asyncSnapshot.hasError) {
        } else {
          return Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 72.0,
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.45),
                    child: ServerList(),
                  ),
                ),
                state.mobile.value
                    ? Expanded(child: _channelList())
                    : SizedBox(width: 240, child: _channelList()),
                !state.mobile.value
                    ? Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: state.currentChannel,
                          builder: (context, value, child) {
                            return MessageArea(
                              key: ValueKey(value),
                              channelID: state.currentChannel.value,
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _channelList() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      child: ValueListenableBuilder(
        valueListenable: state.currentServer,
        builder: (context, value, child) {
          return ChannelList(key: ValueKey(value), serverID: value);
        },
      ),
    );
  }
}
