import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/user_card.dart';
import 'package:flutter/material.dart';

class UserPanel extends StatefulWidget {
  const UserPanel({super.key, required this.isDemo});
  final bool isDemo;

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  late Future<void> _userInfoLoaded;
  late final UserSchema _user;

  @override
  void initState() {
    _userInfoLoaded = fetchFriends();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchFriends() async {
    if (!widget.isDemo) {
      try {
        final response = await dio.get('/api/v1/user');
        setState(() {
          _user = UserSchema.fromJson(response.data);
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
    return FutureBuilder(
      future: _userInfoLoaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          return Text(error.toString());
        }

        return Material(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  // child: UserCard(user: _user, onClicked: (_) => {}),
                  child: InkWell(
                    onTap: () => {},
                    onHover: (value) => setState(() {
                      // isHovering = value;
                    }),
                    mouseCursor: SystemMouseCursors.click,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: UserCardRaw(user: _user, onClicked: (_) => {}),
                    ),
                  ),
                ),
                _iconButton(() => {}, const Icon(Icons.settings)),
              ],
            ),
          ),
        );
      },
    );
  }

  IconButton _iconButton(void Function()? onPressed, Icon icon) {
    return IconButton(
      onPressed: onPressed,
      mouseCursor: SystemMouseCursors.click,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: icon,
    );
  }
}
