import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:dio/dio.dart';

// fetch the server's channels
Future<List<ChannelSchema>> fetchChannels(
  bool isDemo,
  int serverId,
  int sessionId,
) async {
  log('Requesting channels of server ID $serverId');

  if (isDemo) {
    return List.generate(26, (index) {
      return ChannelSchema(
        id: index,
        serverId: serverId,
        name: 'Channel $index',
      );
    });
  }

  final response = await dio.get(
    '/api/v1/server/$serverId/channels',
    options: Options(headers: {'Session-ID': sessionId}),
  );

  return ChannelSchema.fromJsonList(response.data);
}
