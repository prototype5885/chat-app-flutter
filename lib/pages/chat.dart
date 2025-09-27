import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/tabs/home.dart';
import 'package:flutter/material.dart';
import 'tabs/settings.dart';

class ChatPage extends StatefulWidget {
  final bool isDemo;

  const ChatPage({super.key, required this.isDemo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Home(isDemo: widget.isDemo),
      Text(lang.notifications),
      Settings(isDemo: widget.isDemo),
    ];

    return Scaffold(
      body: Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: lang.home, icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              label: lang.notifications,
              icon: Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(label: lang.you, icon: Icon(Icons.circle)),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
