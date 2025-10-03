import 'dart:developer';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

import '../dio_client.dart';
import '../macros.dart';
import '../websocket.dart' as ws;
import '../widgets/delayed_loading_indicator.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with AutomaticKeepAliveClientMixin {
  late Future<void> sessionLoaded;

  @override
  void initState() {
    if (!state.demo.value) {
      sessionLoaded = (() async {
        log("Fetching session ID...");
        await dioClient.dio.get('/api/auth/newSession');

        await ws.connect();
      })();
    } else {
      sessionLoaded = Future.value();
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
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.45),
      child: SafeArea(
        child: FutureBuilder(
          future: sessionLoaded,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return DelayedLoadingIndicator();
            }
            if (asyncSnapshot.hasError) {
              return handleError(asyncSnapshot.error);
            }
        
            return Scaffold(body: ServerList());
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
