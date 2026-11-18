import 'dart:developer';

import 'package:chat_app_flutter/features/chat/channel_title.dart';
import 'package:chat_app_flutter/features/chat/top.dart';
import 'package:chat_app_flutter/features/icons/hashtag.dart';
import 'package:chat_app_flutter/features/shared/middle_click_scroll.dart';
import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/features/shared/button_list.dart';
import 'package:chat_app_flutter/features/shared/divider_wrapper.dart';
import 'package:chat_app_flutter/features/shared/context_menu.dart';
import 'package:chat_app_flutter/features/shared/context_menu_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:chat_app_flutter/features/chat/data_sources/channels.dart'
    as api;

class ChannelList extends StatefulWidget {
  const ChannelList({
    super.key,
    required this.isDemo,
    required this.server,
    required this.sessionId,
    required this.userId,
    required this.onChannelSelect,
  });

  final bool isDemo;
  final ServerSchema server;
  final int sessionId;
  final int userId;
  final Function(ChannelSchema) onChannelSelect;

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  final ScrollController scrollController = ScrollController();
  late Future<void> _channelListLoaded;
  late List<ChannelSchema> _channelList = [];
  ChannelSchema? currentChannel;

  @override
  void initState() {
    _channelListLoaded = _loadData();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final channels = await api.fetchChannels(
      widget.isDemo,
      widget.server.id!,
      widget.sessionId,
    );
    // TODO handle error
    if (!mounted) return;
    setState(() => _channelList = channels);

    if (!state.mobile.value && _channelList.isNotEmpty) {
      selectChannel(_channelList.first);
    }
  }

  void selectChannel(ChannelSchema channel) {
    setState(() {
      currentChannel = channel;
    });
    log("Selected channel ID ${channel.id}");
    widget.onChannelSelect(channel);
  }

  // if mobile then show the chat on the screen
  // if (state.mobile.value && currentChannel != null) {
  //   Navigator.of(context).push(
  //     CupertinoPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(title: Text(currentChannel!.name)),
  //         body: SafeArea(
  //           child: MessageList(
  //             key: ValueKey(currentChannel!.id),
  //             isDemo: widget.isDemo,
  //             channel: currentChannel!,
  //             sessionId: widget.sessionId,
  //             userId: widget.userId,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top(childWidget: Center(child: Text(widget.server.name))),
        dividerX(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: _channelListLoaded,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  final error = asyncSnapshot.error;
                  return Text(error.toString());
                }

                return MiddleClickScroll(
                  controller: scrollController,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 72),
                      itemCount: _channelList.length,
                      itemBuilder: (context, index) {
                        final channel = _channelList[index];
                        return CtxMenu(
                          buttons: _contextMenuButtons(channel),
                          builder: (context, controller, child) {
                            return ButtonList(
                              onClicked: () => selectChannel(channel),
                              selected: channel.id == currentChannel?.id,
                              horizontalTitleGap: 8,
                              leading: const Hashtag(),
                              title: ChannelTitle(name: channel.name),
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
        ),
      ],
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
