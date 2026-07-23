import 'dart:developer';

import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/button_list.dart';
import 'package:chat_app_flutter/widgets/divider_wrapper.dart';
import 'package:chat_app_flutter/widgets/member_list.dart';
import 'package:chat_app_flutter/widgets/message_list.dart';
import 'package:chat_app_flutter/widgets/context_menu.dart';
import 'package:chat_app_flutter/widgets/context_menu_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/top.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({
    super.key,
    required this.isDemo,
    required this.server,
    required this.sessionId,
    required this.userId,
  });
  final bool isDemo;
  final ServerSchema server;
  final int sessionId;
  final int userId;

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late Future<void> _channelListLoaded;
  late List<ChannelSchema> _channelList = [];
  ChannelSchema? currentChannel;

  @override
  void initState() {
    _channelListLoaded = fetchChannels();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchChannels() async {
    if (!widget.isDemo) {
      final response = await dio.get(
        '/api/v1/server/${widget.server.id}/channels',
        options: Options(headers: {'Session-ID': widget.sessionId}),
      );
      setState(() {
        _channelList = ChannelSchema.fromJsonList(response.data);
      });
    } else {
      setState(() {
        for (int i = 0; i < 5; i++) {
          _channelList.add(
            ChannelSchema(
              id: i,
              serverId: widget.server.id,
              name: 'Channel ${i + 1}',
            ),
          );
        }
      });
    }

    if (!state.mobile.value && _channelList.isNotEmpty) {
      selectChannel(_channelList.first.id);
    }
  }

  void selectChannel(int channelId) {
    for (int i = 0; i < _channelList.length; i++) {
      if (_channelList[i].id == channelId) {
        setState(() {
          currentChannel = _channelList[i];
        });
        log("Selected channel ID $channelId");
        break;
      }
    }

    // if mobile then show the chat on the screen
    if (state.mobile.value && currentChannel != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(currentChannel!.name)),
            body: SafeArea(
              child: MessageList(
                key: ValueKey(currentChannel!.id),
                isDemo: widget.isDemo,
                channel: currentChannel!,
                sessionId: widget.sessionId,
                userId: widget.userId,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: [
          // if on mobile make channels take up remaining of screen
          // as messages won't be displayed right from it
          state.mobile.value
              ? Expanded(
                  child: Material(
                    color: colorScheme.surfaceContainerLowest,
                    child: _channelListWidget(),
                  ),
                )
              : Material(
                  color: colorScheme.surfaceContainerLowest,
                  child: SizedBox(width: 240, child: _channelListWidget()),
                ),

          // display messages on desktop
          if (!state.mobile.value && currentChannel != null)
            Expanded(
              child: Column(
                children: [
                  Top(
                    childWidget: currentChannel != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                _hashtag(),
                                _channelTitle(currentChannel!.name),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                  dividerX(),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: MessageList(
                            key: ValueKey(currentChannel),
                            isDemo: widget.isDemo,
                            channel: currentChannel!,
                            sessionId: widget.sessionId,
                            userId: widget.userId,
                          ),
                        ),
                        dividerY(),
                        MemberList(
                          key: ValueKey(widget.server.id),
                          isDemo: widget.isDemo,
                          serverId: widget.server.id,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _channelListWidget() {
    return Column(
      children: [
        Top(childWidget: Center(child: Text(widget.server.name))),
        dividerX(),
        Expanded(
          child: FutureBuilder(
            future: _channelListLoaded,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                final error = asyncSnapshot.error;
                return Text(error.toString());
              }

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _channelList.length,
                    itemBuilder: (context, index) {
                      final channel = _channelList[index];
                      return CtxMenu(
                        buttons: _contextMenuButtons(channel),
                        builder: (context, controller, child) {
                          return ButtonList(
                            onClicked: () => selectChannel(channel.id),
                            selected: channel.id == currentChannel?.id,
                            horizontalTitleGap: 8,
                            leading: _hashtag(),
                            title: _channelTitle(channel.name),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Transform _hashtag() {
    return Transform(
      transform: Matrix4.skewX(-0.2),
      child: const Icon(Icons.tag),
    );
  }

  Text _channelTitle(String name) {
    return Text(
      name,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  List<Widget> _contextMenuButtons(ChannelSchema c) {
    final owner = widget.server.ownerId == widget.userId;
    final loc = AppLocalizations.of(context)!;

    return [
      if (owner)
        CtxMenuButton(
          label: loc.edit,
          leadingIcon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: () {
            log("Edit channel ID ${c.id}");
          },
        ),
      if (owner) ctxMenuDivier(),
      if (owner)
        CtxMenuButton(
          label: loc.delete,
          leadingIcon: const Icon(Icons.delete_outline, size: 18),
          onPressed: () {
            log("Delete channel ID ${c.id}");
          },
          type: CtxMenuButtonVariant.red,
        ),
      if (owner) ctxMenuDivier(),
      CtxMenuButton(
        label: loc.copyChannelId,
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of channel ID ${c.id}");
          await Clipboard.setData(ClipboardData(text: c.id.toString()));
        },
      ),
    ];
  }
}
