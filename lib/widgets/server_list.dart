import 'dart:developer';

import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/channel_list.dart';
import 'package:chat_app_flutter/widgets/member_list.dart';
import 'package:chat_app_flutter/widgets/server_base.dart';
import 'package:chat_app_flutter/widgets/context_menu.dart';
import 'package:chat_app_flutter/widgets/context_menu_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int _directMessagesServerId = 100;

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
  int? currentServerId;

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

  ServerSchema getCurrentServerById(int serverId) {
    for (int i = 0; i < serverList.length; i++) {
      if (serverList[i].id == serverId) {
        return serverList[i];
      }
    }
    throw 'Failed to find server in getCurrentServer for server ID $serverId';
  }

  void selectServer(int serverId) {
    setState(() {
      currentServerId = serverId;
    });
  }

  void deleteServer(int serverId) {
    log('Deleting server ID $serverId from local server list');
    for (int i = 0; i < serverList.length; i++) {
      if (serverList[i].id == serverId) {
        setState(() {
          serverList.remove(serverList[i]);
          currentServerId = _directMessagesServerId;
        });
        return;
      }
    }
  }

  Future<void> createServerRequest() async {
    log('Requesting to create server');
    try {
      final result = await dio.post(
        '/api/v1/server',
        data: {'name': 'Server'},
        options: Options(contentType: Headers.jsonContentType),
      );

      final server = ServerSchema.fromJson(result.data);
      setState(() {
        serverList.add(server);
      });
    } on Exception catch (e) {
      // TODO
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        ServerBase(
                          id: _directMessagesServerId,
                          name: 'DM',
                          selected: _directMessagesServerId == currentServerId,
                          onClicked: selectServer,
                          centeredChild: const Icon(
                            Icons.mail_outline,
                            size: 28,
                          ),
                        ),
                        if (serverList.isNotEmpty) _serverDivider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: serverList.length,
                          itemBuilder: (context, index) {
                            final server = serverList[index];
                            return CtxMenu(
                              buttons: _contextMenuButtons(server),
                              builder: (context, controller, child) {
                                return ServerBase(
                                  key: ValueKey(server.name),
                                  id: server.id,
                                  name: server.name,
                                  pic: server.picture,
                                  selected: server.id == currentServerId,
                                  onClicked: selectServer,
                                );
                              },
                            );
                          },
                        ),
                        _serverDivider(),
                        ServerBase(
                          id: -1,
                          name: '+',
                          selected: false,
                          onClicked: (_) async => createServerRequest(),
                          centeredChild: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _channelFriendList(),
            const VerticalDivider(width: 1),
            const MemberList(),
          ],
        );
      },
    );
  }

  Widget _channelFriendList() {
    if (currentServerId == null) {
      return const Text('No server selected');
    }

    if (currentServerId == _directMessagesServerId) {
      return const Text('dm');
    }

    return ChannelList(
      key: ValueKey(currentServerId),
      isDemo: widget.isDemo,
      server: getCurrentServerById(currentServerId!),
      sessionId: widget.sessionId,
      userId: widget.userId,
    );
  }

  Widget _serverDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(),
    );
  }

  List<Widget> _contextMenuButtons(ServerSchema s) {
    final owner = s.ownerId == widget.userId;
    final loc = AppLocalizations.of(context)!;

    return [
      if (owner)
        CtxMenuButton(
          label: loc.edit,
          leadingIcon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: () {
            log("Edit server ID ${s.id}");
          },
        ),
      if (owner) ctxMenuDivier(),
      if (owner)
        CtxMenuButton(
          label: loc.delete,
          leadingIcon: const Icon(Icons.delete_outline, size: 18),
          onPressed: () {
            log("Delete server ID ${s.id}");
          },
          type: CtxMenuButtonVariant.red,
        ),
      if (owner) ctxMenuDivier(),
      CtxMenuButton(
        label: loc.copyId,
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of Server ID ${s.id}");
          await Clipboard.setData(ClipboardData(text: s.id.toString()));
        },
      ),
    ];
  }
}
