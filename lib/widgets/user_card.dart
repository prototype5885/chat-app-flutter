import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:chat_app_flutter/widgets/button_list.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.onClicked});
  final UserSchema user;
  final Function(int) onClicked;

  @override
  Widget build(BuildContext context) {
    return ButtonList(
      onClicked: () => onClicked(user.id),
      title: UserCardRaw(user: user, onClicked: onClicked),
    );
  }
}

class UserCardRaw extends StatelessWidget {
  const UserCardRaw({super.key, required this.user, required this.onClicked});
  final UserSchema user;
  final Function(int) onClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Avatar(size: 32, pic: user.picture, name: user.displayName),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text(
                user.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (user.customStatus != null)
                Text(
                  user.customStatus!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1, fontSize: 11),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
