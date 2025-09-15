import 'package:chat_app_flutter/mobile_pages/tabs/home.dart';
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
      MobileHome(),
      Text('Notifications'),
      MobileSettings(isDemo: widget.isDemo),
    ];

    return Scaffold(
      body: Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              label: 'Notifications',
              icon: Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(label: 'You', icon: Icon(Icons.circle)),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
