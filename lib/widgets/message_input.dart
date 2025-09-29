import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final String channelID;

  const MessageInput({super.key, required this.channelID});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        maxLines: 12,
        minLines: 1,
        decoration: InputDecoration(
          labelText: "Message...",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 16.0,
          ),

          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.05),
              width: 1,
            ),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              width: 1,
            ),
          ),

          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 0.05),
        ),
      ),
    );
  }
}
