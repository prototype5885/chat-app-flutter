import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/context_menu.dart';
import 'package:chat_app_flutter/widgets/user_card.dart';
import 'package:flutter/material.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key, required this.isDemo, required this.serverId});
  final bool isDemo;
  final int serverId;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  late Future<void> _memberListLoaded;
  late List<UserSchema> _memberList = [];

  @override
  void initState() {
    _memberListLoaded = _fetchMembers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchMembers() async {
    if (!widget.isDemo) {
      try {
        final response = await dio.get(
          '/api/v1/server/${widget.serverId}/members',
        );
        setState(() {
          _memberList = UserSchema.fromJsonList(response.data);
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
    return SizedBox(
      width: 265,
      child: FutureBuilder(
        future: _memberListLoaded,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text(error.toString());
          }

          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _memberList.length,
                itemBuilder: (context, index) {
                  final friend = _memberList[index];
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
    );
  }

  List<Widget> _contextMenuButtons(UserSchema u) {
    return [];
  }
}
