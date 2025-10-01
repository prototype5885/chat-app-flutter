import 'package:chat_app_flutter/widgets/channel_list.dart';
import 'package:chat_app_flutter/widgets/message_area.dart';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

class Home extends StatefulWidget {
  final bool isDemo;

  const Home({super.key, required this.isDemo});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 72.0,
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.45),
              child: ServerList(isDemo: widget.isDemo),
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

  Widget _channelList() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      child: ValueListenableBuilder(
        valueListenable: state.currentServer,
        builder: (context, value, child) {
          return ChannelList(
            key: ValueKey(value),
            isDemo: widget.isDemo,
            serverID: value,
          );
        },
      ),
    );
  }
}
