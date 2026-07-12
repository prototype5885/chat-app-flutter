import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/channel_list.dart';
import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  const ServerList({
    super.key,
    required this.isDemo,
    required this.userId,
    required this.sessionId,
  });
  final bool isDemo;
  final int userId;
  final int sessionId;

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late Future<void> serverListLoaded;
  late List<ServerSchema> serverList = [];
  ServerSchema? currentServer;

  @override
  void initState() {
    serverListLoaded = fetchServers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchServers() async {
    if (!widget.isDemo) {
      final response = await dio.get('/api/v1/servers');
      setState(() {
        serverList = (response.data as List<dynamic>)
            .map(
              (jsonMap) =>
                  ServerSchema.fromJson(jsonMap as Map<String, dynamic>),
            )
            .toList();
      });
    } else {
      setState(() {
        final alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));
        serverList = List.generate(26, (index) {
          final letter = alphabet[index % 26];
          return ServerSchema(id: index, ownerId: 0, name: letter);
        });
      });
    }

    if (serverList.isNotEmpty) {
      selectServer(serverList.first.id);
    }
  }

  void selectServer(int serverID) {
    for (int i = 0; i < serverList.length; i++) {
      if (serverList[i].id == serverID) {
        setState(() {
          currentServer = serverList[i];
        });
        log("Selected server ID $serverID");
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: serverListLoaded,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          final error = asyncSnapshot.error;
          if (error is DioException && error.response?.statusCode == 401) {
            return Text(error.response!.statusCode.toString());
          }
        }
        return Row(
          children: [
            Container(
              width: 72,
              height: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                border: Border(right: defaultBorder(colorScheme)),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemCount: serverList.length,
                  itemBuilder: (context, index) {
                    final server = serverList[index];
                    return ServerBase(
                      key: ValueKey(server.name),
                      id: server.id,
                      name: server.name,
                      pic: server.picture,
                      selected: server.id == currentServer?.id,
                      onClicked: selectServer,
                    );
                  },
                ),
              ),
            ),
            currentServer != null
                ? ChannelList(
                    key: ValueKey(currentServer),
                    isDemo: widget.isDemo,
                    server: currentServer!,
                    sessionId: widget.sessionId,
                    userId: widget.userId,
                  )
                : const Center(child: Text('No server selected')),
          ],
        );
      },
    );
  }
}
