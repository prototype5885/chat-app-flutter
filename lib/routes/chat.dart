import 'dart:async';
import 'dart:developer';

import 'package:chat_app_flutter/services/session.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  int userId = 0;
  int sessionId = 0;
  late final bool isDemo;

  String sseErrorMsg = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    isDemo = args['demo']!;

    if (!isDemo) {
      _startSession();
    } else {
      userId = 1;
      sessionId = 1;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.mobile = MediaQuery.of(context).size.width < 600;
      if (!isDemo) {
        events.on('user_id', (String msg) {
          setState(() {
            userId = int.parse(msg);
          });
          log('User ID has been set to: $userId');
        });

        events.on('session_id', (String msg) {
          setState(() {
            sessionId = int.parse(msg);
          });
          log('Session ID has been set to: $sessionId');
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _startSession() async {
    log('Attempting to connect to session...');
    try {
      await connectSSE();
    } catch (e) {
      if (userId != 0 || sessionId != 0) {
        setState(() {
          userId = 0;
          sessionId = 0;
        });
      }

      sseErrorMsg = e.toString();
      await Future.delayed(const Duration(seconds: 5));
      sseErrorMsg = "";
      await _startSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (userId == 0 && sessionId == 0)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Trying to connect to SSE stream...'),
                    const SizedBox(height: 16),
                    Text(sseErrorMsg),
                  ],
                ),
              )
            : ServerList(isDemo: isDemo, userId: userId, sessionId: sessionId),
      ),
    );
  }
}
