import 'dart:developer';

import 'package:chat_app_flutter/macros.dart' as macros;
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String id;
  final String userID;
  final String name;
  final String pic;
  final String msg;

  const Message({
    super.key,
    required this.id,
    required this.userID,
    required this.name,
    required this.pic,
    required this.msg,
  });

  void pressed() {
    log("Avatar pressed for ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(size: 40, pic: pic, name: name, pressed: pressed),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        log('User name pressed for ID: $userID');
                      },
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        macros.extractDate(id, macros.SnowflakeDateFormat.long),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                SelectableText(msg, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
