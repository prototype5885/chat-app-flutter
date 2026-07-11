import 'dart:convert';

import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final events = EventEmitter();

class SseEvent {
  static const String userId = "user_id";
  static const String sessionId = "session_id";
  static const String selfUserInfo = "self_user_info";
  static const String userInfo = "user_info";
  static const String serverInfo = "server_info";
  static const String deleteServer = "delete_server";
  static const String createChannel = "create_channel";
  static const String modifyChannel = "modify_channel";
  static const String deleteChannel = "delete_channel";
  static const String createMessage = "create_message";
  static const String editMessage = "edit_message";
  static const String deleteMessage = "delete_message";
  static const String typing = "typing";
  static const String userOnline = "user_online";
}

Future<void> connectSSE() async {
  final client = http.Client();

  final request = http.Request('GET', Uri.parse('$backend/api/v1/session'));
  request.headers['Accept'] = 'text/event-stream';
  request.headers['Cache-Control'] = 'no-cache';
  if (!kIsWeb) request.headers.addAll(getTokenCookieHeader());

  final response = await client.send(request);

  final stream = response.stream;
  final buffer = StringBuffer();

  await for (final chunk in stream) {
    buffer.write(utf8.decode(chunk));
    final blocks = buffer.toString().split('\n\n');

    buffer.clear();
    buffer.write(blocks.removeLast());

    for (final block in blocks) {
      if (block.trim().isEmpty) continue;

      String event = "";
      String data = "";

      for (final line in block.split('\n')) {
        if (line.startsWith('event:')) {
          event = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          data = line.substring(5).trim();
        }
      }

      events.emit(event, data);
    }
  }

  client.close();
  throw Exception('SSE stream closed');
}
