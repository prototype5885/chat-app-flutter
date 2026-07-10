import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  late Future<void> userIdReceived;
  late final int userId;

  @override
  void initState() {
    userIdReceived = _fetchUserID();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchUserID() async {
    final response = await dio.get('/api/v1/user_id');
    setState(() {
      userId = int.parse(response.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    // wait until user ID is received
    return FutureBuilder(
      future: userIdReceived,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: Text('Getting user ID...')),
          );
        } else if (asyncSnapshot.hasError) {
          return Text(asyncSnapshot.error.toString());
        } else {
          return const Scaffold(body: SafeArea(child: ServerList()));
        }
      },
    );
  }
}
