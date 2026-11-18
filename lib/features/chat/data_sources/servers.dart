import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:dio/dio.dart';

// fetch the servers the user is in
Future<List<ServerSchema>> fetchServers(bool isDemo) async {
  log('Requesting server list');

  if (isDemo) {
    final alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));
    return List.generate(26, (index) {
      final letter = alphabet[index % 26];
      return ServerSchema(id: index, ownerId: 0, name: letter);
    });
  }

  final response = await dio.get('/api/v1/servers');

  return ServerSchema.fromJsonList(response.data);
}

// request to create server
Future<ServerSchema> createServerRequest(bool isDemo, String name) async {
  log('Requesting to create server');

  if (isDemo) {
    return ServerSchema(name: "Demo server");
  }

  final response = await dio.post(
    '/api/v1/server',
    data: {'name': name},
    options: Options(contentType: Headers.jsonContentType),
  );

  return ServerSchema.fromJson(response.data);
}
