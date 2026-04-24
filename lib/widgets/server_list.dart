import 'dart:developer';

import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late String currentServerID = "";
  late Future<void> serverListLoaded;
  late List<ServerSchema> serverList = [];

  @override
  void initState() {
    // if (state.demo.value) {
    //   serverList = List.generate(50, (index) {
    //     final serverNumber = index + 1;
    //     return ServerSchema(
    //       id: serverNumber.toString(),
    //       ownerId: '0',
    //       name: serverNumber.toString(),
    //       picture: '',
    //       banner: '',
    //       roles: '',
    //     );
    //   });
    //   serverListLoaded = Future.value();
    // } else {
    serverListLoaded = fetchServers();
    // }
    // fetchServers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchServers() async {
    final response = await dio.get('/api/v1/servers');

    setState(() {
      serverList = (response.data as List<dynamic>)
          .map(
            (jsonMap) => ServerSchema.fromJson(jsonMap as Map<String, dynamic>),
          )
          .toList();
    });

    if (serverList.isNotEmpty) {
      selectServer(serverList.first.id);
    }
  }

  void selectServer(String serverID) {
    final results = serverList.where((server) => server.id == serverID);
    if (results.isNotEmpty) {
      setState(() {
        currentServerID = results.first.id;
      });
      log("Selected server ID $serverID");
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
          // return handleError(asyncSnapshot.error);
        }
        return Row(
          children: [
            Container(
              width: 72,
              height: double.infinity,
              color: colorScheme.surfaceContainerLowest,
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
                      selected: server.id == currentServerID,
                      onClicked: selectServer,
                    );
                  },
                ),
              ),
            ),
            // ChannelList(
            //   key: ValueKey(currentServerID),
            //   currentServerID: currentServerID,
            // ),
          ],
        );
      },
    );
  }
}
