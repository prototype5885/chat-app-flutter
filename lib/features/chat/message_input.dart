import 'package:chat_app_flutter/l10n/app_localizations.dart';

import 'package:chat_app_flutter/services/schemas.dart';
import 'package:chat_app_flutter/services/states.dart' as state;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:chat_app_flutter/features/chat/data_sources/messages.dart'
    as api;

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.isDemo, required this.channel});
  final bool isDemo;
  final ChannelSchema channel;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  static const double borderRadius = 8;
  late final TextEditingController controller;
  late FocusNode focusNode;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final String message = controller.text.trim();

    if (message.isEmpty) {
      setState(() {
        controller.clear();
      });

      return;
    }

    await api.sendMessage(widget.isDemo, widget.channel.id, message);
    // TODO handle error

    setState(() {
      controller.clear();
    });
  }

  Future<void> typingValueChanged(String text) async {
    String value = "";
    if (text.isNotEmpty && !isTyping) {
      isTyping = true;
      value = "start";
    } else if (text.isEmpty && isTyping) {
      isTyping = false;
      value = "stop";
    }

    if (value.isNotEmpty) {
      await api.typing(widget.isDemo, widget.channel.id, value);
      // TODO handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Focus(
        child: KeyboardListener(
          focusNode: focusNode,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter) {
                if (HardwareKeyboard.instance.isShiftPressed) {
                  controller.text += '\n';
                } else {
                  sendMessage();
                }
              }
            }
          },
          child: TextField(
            controller: controller,
            onChanged: (String value) async {
              await typingValueChanged(value);
            },
            textInputAction: TextInputAction.none,
            autofocus: state.mobile.value ? false : true,
            autocorrect: true,
            cursorColor: Colors.white,
            cursorWidth: 1,
            maxLines: 12,
            minLines: 1,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
              hintText: loc.message('@${widget.channel.name}'),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 21,
              ),

              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: () {},
                ),
              ),

              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: sendMessage,
                ),
              ),

              filled: true,
              fillColor: colorScheme.surfaceContainer,

              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                borderSide: BorderSide(
                  color: colorScheme.brightness == Brightness.dark
                      ? const Color.fromRGBO(255, 255, 255, 0.03)
                      : const Color.fromRGBO(0, 0, 0, 0.15),
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                borderSide: BorderSide(
                  color: colorScheme.brightness == Brightness.dark
                      ? const Color.fromRGBO(255, 255, 255, 0.1)
                      : const Color.fromRGBO(0, 0, 0, 0.5),
                  width: 1,
                ),
              ),

              hoverColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
