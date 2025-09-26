import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
          ServerList(),
          Expanded(
            child: Center(
              child: Text('stuff', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
