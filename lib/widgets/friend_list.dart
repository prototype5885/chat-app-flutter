import 'dart:developer';

import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:chat_app_flutter/widgets/button_list.dart';
import 'package:chat_app_flutter/widgets/context_menu.dart';
import 'package:chat_app_flutter/widgets/context_menu_button.dart';
import 'package:chat_app_flutter/widgets/top.dart';
import 'package:chat_app_flutter/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FriendList extends StatefulWidget {
  const FriendList({
    super.key,
    required this.isDemo,
    required this.sessionId,
    required this.userId,
  });
  final bool isDemo;
  final int sessionId;
  final int userId;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  late Future<void> _friendListLoaded;
  late List<UserSchema> _friendList = [];

  @override
  void initState() {
    _friendListLoaded = fetchFriends();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchFriends() async {
    if (!widget.isDemo) {
      try {
        final response = await dio.get('/api/v1/friends');
        setState(() {
          _friendList = UserSchema.fromJsonList(response.data);
        });
      } on Exception catch (e) {
        // TODO
      }
    } else {
      // TODO demo
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: [
          // if on mobile make friends list take up remaining of screen
          state.mobile.value
              ? Expanded(
                  child: Material(
                    color: colorScheme.surfaceContainerLowest,
                    child: _friendListWidget(),
                  ),
                )
              : Material(
                  color: colorScheme.surfaceContainerLowest,
                  child: SizedBox(width: 240, child: _friendListWidget()),
                ),

          // display on desktop
          // if (!state.mobile.value)
          //   Expanded(
          //     child: ,
          //   ),
        ],
      ),
    );
  }

  Widget _friendListWidget() {
    return Column(
      children: [
        const Top(childWidget: Center(child: Text('Friends'))),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ButtonList(
                onClicked: () => {
                  // TODO
                },
                leading: const Icon(Icons.people),
                titleText: 'Friends',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder(
            future: _friendListLoaded,
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
                    itemCount: _friendList.length,
                    itemBuilder: (context, index) {
                      final friend = _friendList[index];
                      return CtxMenu(
                        buttons: _contextMenuButtons(friend),
                        builder: (context, controller, child) {
                          return UserCard(
                            key: ValueKey(friend.id),
                            user: friend,
                            onClicked: (id) => {},
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

  List<Widget> _contextMenuButtons(UserSchema u) {
    final loc = AppLocalizations.of(context)!;

    return [
      CtxMenuButton(
        label: loc.block,
        leadingIcon: const Icon(Icons.block, size: 18),
        onPressed: () {
          log("Block user ID ${u.id}");
        },
        type: CtxMenuButtonVariant.red,
      ),
      CtxMenuButton(
        label: loc.unfriend,
        leadingIcon: const Icon(Icons.person_remove, size: 18),
        onPressed: () {
          log("Unfriend user ID ${u.id}");
        },
        type: CtxMenuButtonVariant.red,
      ),
      ctxMenuDivier(),
      CtxMenuButton(
        label: loc.copyUserId,
        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
        onPressed: () async {
          log("Copy ID of User ID ${u.id}");
          await Clipboard.setData(ClipboardData(text: u.id.toString()));
        },
      ),
    ];
  }
}
