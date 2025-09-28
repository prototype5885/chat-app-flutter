import 'package:chat_app_flutter/widgets/channel_list.dart';
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
          SizedBox(
            width: 240.0,
            child: Container(
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
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder(
                    valueListenable: state.currentServer,
                    builder: (context, value, child) {
                      return Text(
                        "Server: $value",
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: state.currentChannel,
                    builder: (context, value, child) {
                      return Text(
                        "Channel: $value",
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
