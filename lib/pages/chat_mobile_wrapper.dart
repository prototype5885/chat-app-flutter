import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/chat.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

class ChatMobileWrapper extends StatefulWidget {
  const ChatMobileWrapper({super.key});

  @override
  State<ChatMobileWrapper> createState() => _ChatMobileWrapperState();
}

class _ChatMobileWrapperState extends State<ChatMobileWrapper> {
  int selectedTab = 0;

  late final List<Widget> widgetOptions = <Widget>[
    const Chat(),
    Text(lang.notifications),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedTab, children: widgetOptions),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: lang.home,
              icon: const Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: lang.notifications,
              icon: const Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(
              label: lang.you,
              icon: const Icon(Icons.circle),
            ),
          ],
          currentIndex: selectedTab,
          onTap: (int index) {
            setState(() {
              selectedTab = index;
            });
          },
        ),
      ),
    );
  }
}
