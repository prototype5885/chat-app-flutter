import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.onClicked});
  final UserSchema user;
  final Function(int) onClicked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          onClicked(user.id);
        },
        selectedTileColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.onSurface,
        splashColor: Colors.transparent,
        dense: true,
        horizontalTitleGap: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Row(
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
        ),
      ),
    );
  }
}
