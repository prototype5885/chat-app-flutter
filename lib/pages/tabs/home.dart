import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

class Home extends StatefulWidget {
  final bool isDemo;

  const Home({super.key, required this.isDemo});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ServerList(isDemo: widget.isDemo),
          Expanded(
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: state.currentServer,
                builder: (context, value, child) {
                  return Text(value, style: TextStyle(color: Colors.white));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
