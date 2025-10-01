import 'dart:developer';

import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/tabs/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../dio_client.dart';
import '../websocket.dart' as ws;
import 'tabs/settings.dart';
import 'package:chat_app_flutter/state.dart' as state;

class ChatPage extends StatefulWidget {
  final bool isDemo;

  const ChatPage({super.key, required this.isDemo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<void> _loaded;
  int _selectedIndex = 0;

  @override
  void initState() {
    if (!widget.isDemo) {
      _loaded = _createSession();
    } else {
      _loaded = Future.value();
    }

    super.initState();
  }

  @override
  void dispose() {
    ws.disconnect();
    super.dispose();
  }

  Future<void> _createSession() async {
    try {
      log("Fetching session ID...");
      await dioClient.dio.get('/api/auth/newSession');
    } on DioException catch (e) {
      debugPrint('$e');
      return;
    } catch (e) {
      debugPrint('$e');
      return;
    }

    await ws.connect();
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

    return FutureBuilder(
      future: _loaded,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            body: Center(child: widgetOptions.elementAt(_selectedIndex)),
            bottomNavigationBar: state.mobile.value
                ? Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(splashFactory: NoSplash.splashFactory),
                    child: BottomNavigationBar(
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          label: lang.home,
                          icon: Icon(Icons.home),
                        ),
                        BottomNavigationBarItem(
                          label: lang.notifications,
                          icon: Icon(Icons.notifications),
                        ),
                        BottomNavigationBarItem(
                          label: lang.you,
                          icon: Icon(Icons.circle),
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                    ),
                  )
                : null,
          );
        }
      },
    );
  }
}
