import 'package:chat_app_flutter/features/chat/channel_list.dart';
import 'package:chat_app_flutter/features/chat/channel_title.dart';
import 'package:chat_app_flutter/features/chat/member_list.dart';
import 'package:chat_app_flutter/features/chat/message_list.dart';
import 'package:chat_app_flutter/features/chat/top.dart';
import 'package:chat_app_flutter/features/icons/hashtag.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/features/chat/server_list.dart';
import 'package:chat_app_flutter/features/chat/user_panel.dart';
import 'package:chat_app_flutter/features/shared/divider_wrapper.dart';
import 'package:material_ui/material_ui.dart';

class Chat extends StatefulWidget {
  const Chat({
    super.key,
    required this.isDemo,
    required this.userId,
    required this.sessionId,
  });
  final bool isDemo;
  final int userId;
  final int sessionId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Widget? _channelOrDm;
  Widget? _mainArea;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget channelOrDmPanel() {
      return (_channelOrDm != null)
          ? _channelOrDm!
          : const Text('Nothing is selected');
    }

    return Row(
      children: [
        // server, channel, dm list
        Stack(
          children: [
            Row(
              children: [
                // server list
                ServerList(
                  isDemo: widget.isDemo,
                  userId: widget.userId,
                  sessionId: widget.sessionId,
                  onDmSelected: () {
                    setState(() {
                      _channelOrDm = const Text('dm');
                    });
                  },
                  onServerSelect: (server) {
                    setState(() {
                      _channelOrDm = ChannelList(
                        key: ValueKey(server),
                        isDemo: widget.isDemo,
                        server: server,
                        sessionId: widget.sessionId,
                        userId: widget.userId,
                        onChannelSelect: (channel) {
                          setState(() {
                            _mainArea = _chatArea(server, channel);
                          });
                        },
                      );
                    });
                  },
                ),

                dividerY(),

                // channel or dm panel
                state.mobile.value
                    // if on mobile make it take up remaining of screen
                    ? Expanded(
                        child: Material(
                          color: colorScheme.surfaceContainerLowest,
                          child: SizedBox(child: channelOrDmPanel()),
                        ),
                      )
                    : Material(
                        color: colorScheme.surfaceContainerLowest,
                        child: SizedBox(width: 240, child: channelOrDmPanel()),
                      ),
              ],
            ),
            _userPanelArea(),
          ],
        ),

        // chat, friend list, etc
        (_mainArea != null) ? _mainArea! : const Text('Nothing here'),
      ],
    );
  }

  Widget _userPanelArea() {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 0,
      child: Container(
        width: 240 + 72,
        height: 74,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surfaceContainerLowest.withValues(alpha: 0.0),
              colorScheme.surfaceContainerLowest.withValues(alpha: 0.98),
              colorScheme.surfaceContainerLowest.withValues(alpha: 1.0),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: colorScheme.brightness == Brightness.dark
                    ? const Color.fromRGBO(255, 255, 255, 0.03)
                    : const Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: UserPanel(isDemo: widget.isDemo),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatArea(ServerSchema server, ChannelSchema channel) {
    return Expanded(
      child: Column(
        children: [
          Top(
            childWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Hashtag(),
                  ChannelTitle(name: channel.name),
                ],
              ),
            ),
          ),
          dividerX(),
          Expanded(
            child: Row(
              children: [
                MessageList(
                  key: ValueKey(channel),
                  isDemo: widget.isDemo,
                  channel: channel,
                  sessionId: widget.sessionId,
                  userId: widget.userId,
                ),
                dividerY(),
                MemberList(
                  key: ValueKey(server),
                  isDemo: widget.isDemo,
                  serverId: server.id!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
