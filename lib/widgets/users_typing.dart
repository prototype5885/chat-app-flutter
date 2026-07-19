import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/services/session.dart';
import 'package:chat_app_flutter/widgets/typing_dots.dart';
import 'package:flutter/material.dart';

class UsersTyping extends StatefulWidget {
  const UsersTyping({
    super.key,
    required this.userId,
    required this.isAtBottom,
  });
  final int userId;
  final bool isAtBottom;

  @override
  State<UsersTyping> createState() => UsersTypingState();
}

class UsersTypingState extends State<UsersTyping>
    with SingleTickerProviderStateMixin {
  Map<int, String> usersTyping = {};
  late final AnimationController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      events.on(SseEvent.typing, (String data) {
        final firstSpace = data.indexOf(' ');
        // secondSpace will be -1 if STOP action is received
        final secondSpace = data.indexOf(' ', firstSpace + 1);

        final action = int.parse(data.substring(0, firstSpace));
        final userId = secondSpace != -1
            ? int.parse(data.substring(firstSpace + 1, secondSpace))
            : int.parse(data.substring(firstSpace + 1));
        final displayname = secondSpace != -1
            ? data.substring(secondSpace + 1)
            : 'Unknown user';

        // don't show myself
        if (widget.userId == userId) {
          return;
        }

        setState(() {
          if (action == 1) {
            usersTyping[userId] = displayname;
          } else {
            usersTyping.remove(userId);
          }
        });

        if (usersTyping.isNotEmpty && !_controller.isAnimating) {
          _controller.repeat();
        } else if (usersTyping.isEmpty) {
          _controller.reset();
        }
      });
    });

    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    events.off(type: SseEvent.typing);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return usersTyping.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: !widget.isAtBottom
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.surface.withValues(alpha: 0.0),
                        colorScheme.surface.withValues(alpha: 0.9),
                        colorScheme.surface.withValues(alpha: 1.0),
                      ],
                    ),
                  )
                : null,
            height: 48,

            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    TypingDots(animation: _controller),
                    const SizedBox(width: 12),
                    Text(usersTyping.values.join(', ')),
                    usersTyping.length > 1
                        ? Text(loc.areTyping)
                        : Text(loc.isTyping),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
