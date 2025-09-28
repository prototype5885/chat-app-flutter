import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/state.dart' as state;

import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio_client.dart';

class ServerList extends StatefulWidget {
  final bool isDemo;

  const ServerList({super.key, required this.isDemo});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late Future<void> serverListLoaded;
  late List<ServerModel> serverList = [];

  @override
  void initState() {
    if (widget.isDemo) {
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
    try {
      log("Fetching servers...");
      final response = await dioClient.dio.get('/api/server/fetch');
      final List<dynamic> rawList = jsonDecode(response.data);

      setState(() {
        serverList = rawList
            .map(
              (jsonMap) =>
                  ServerModel.fromJson(jsonMap as Map<String, dynamic>),
            )
            .toList();
      });
    } on DioException catch (e) {
      debugPrint('$e');
      setState(() {
        if (e.type == DioExceptionType.connectionError) {
          // _loggedInText = lang.serverOffline;
        } else if (e.type == DioExceptionType.badResponse) {
          // _loggedInText = lang.notLoggedIn;
        } else {
          // _loggedInText = e.type.toString();
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  void selectServer(String serverID) {
    log("Selected server ID $serverID");
    if (serverList.isNotEmpty) {
      ServerModel server = serverList.firstWhere(
        (server) => server.id == serverID,
      );
      setState(() {
        state.currentServer.value = server.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: FutureBuilder(
        future: serverListLoaded,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: serverList.length,
              itemBuilder: (context, index) {
                final server = serverList[index];
                return ServerBase(
                  key: ValueKey(server.name),
                  id: server.id,
                  name: server.name,
                  pic: server.picture,
                  selected: server.id == state.currentServer.value,
                  onClicked: selectServer,
                );
              },
            );
          }
        },
      ),
    );
  }
}
