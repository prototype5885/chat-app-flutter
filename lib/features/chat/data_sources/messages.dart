import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:dio/dio.dart';

// send message to a channel
Future<void> sendMessage(bool isDemo, int channelId, String message) async {
  if (isDemo) return;

  await dio.post(
    '/api/v1/channel/$channelId/message',
    data: {"message": message},
    options: Options(contentType: Headers.formUrlEncodedContentType),
  );
}

// send signal to server that user started or stopped typing in a channel
Future<void> typing(bool isDemo, int channelId, String value) async {
  if (isDemo) return;

  await dio.post('/api/v1/channel/$channelId/typing/$value');
}
