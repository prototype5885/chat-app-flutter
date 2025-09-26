import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/state.dart' as state;

import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  final bool isDemo;

  const ServerList({super.key, required this.isDemo});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late List<ServerModel> serverList;

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
    } else {
      serverList = [];
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectServer(String serverID) {
    if (serverList.isNotEmpty) {
      ServerModel server = serverList.firstWhere(
        (server) => server.id == serverID,
      );
      state.currentServer.value = server.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 72.0,
        child: Container(
          color: Colors.black.withAlpha(45),
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
                  selected: server.id == state.currentServer.value,
                  onClicked: selectServer,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
