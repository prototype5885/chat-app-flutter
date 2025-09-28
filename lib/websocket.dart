import 'dart:io';

import 'package:chat_app_flutter/dio_client.dart';
import 'package:chat_app_flutter/globals.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

late final WebSocketChannel ws;

Future<void> connect() async {
  if (!kIsWeb) {
    List<Cookie> cookies = await cookieJar.loadForRequest(
      Uri.parse(backendHttpAddress),
    );

    List<Cookie> filteredCookies = cookies.where((cookie) {
      return cookie.name == 'JWT' || cookie.name == 'session';
    }).toList();

    String cookieHeader = filteredCookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');

    ws = IOWebSocketChannel.connect(
      backendWsAddress,
      headers: {'Cookie': cookieHeader},
    );
  } else {
    ws = WebSocketChannel.connect(Uri.parse(backendWsAddress));
  }

  await ws.ready;

  ws.stream.listen((message) {
    ws.sink.add('received!');
  });
}

Future<void> disconnect() async {
  ws.sink.close(status.goingAway);
}
