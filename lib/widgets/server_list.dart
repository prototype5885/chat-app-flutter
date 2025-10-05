import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/macros.dart';
import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/widgets/channel_list.dart';

import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:flutter/material.dart';

import '../dio_client.dart';
import 'delayed_loading_indicator.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late String currentServerID = "";
  late Future<void> serverListLoaded;
  late List<ServerModel> serverList = [];

  @override
  void initState() {
    if (state.demo.value) {
      serverList = List.generate(50, (index) {
        final serverNumber = index + 1;
        return ServerModel(
          id: serverNumber.toString(),
          ownerID: '0',
          name: serverNumber.toString(),
          picture: '',
          banner: '',
        );
      });
      serverListLoaded = Future.value();
    } else {
      serverListLoaded = fetchServers();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchServers() async {
    log("Fetching servers...");
    final response = await dioClient.dio.get('/api/server/fetch');
    final List<dynamic> rawList = jsonDecode(response.data);

    setState(() {
      serverList = rawList
          .map(
            (jsonMap) => ServerModel.fromJson(jsonMap as Map<String, dynamic>),
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
    return FutureBuilder(
      future: serverListLoaded,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: DelayedLoadingIndicator());
        }
        if (asyncSnapshot.hasError) {
          return handleError(asyncSnapshot.error);
        }
        return Row(
          children: [
            Container(
              width: 72,
              height: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.45),
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
            ChannelList(
              key: ValueKey(currentServerID),
              currentServerID: currentServerID,
            ),
          ],
        );
      },
    );
  }
}
