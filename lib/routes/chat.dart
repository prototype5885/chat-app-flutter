import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  late Future<void> _userIdReceived;
  late final int userId;
  late final bool isDemo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    isDemo = args['demo']!;
    _userIdReceived = _fetchUserID();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchUserID() async {
    if (!isDemo) {
      final response = await dio.get('/api/v1/user_id');
      setState(() {
        userId = int.parse(response.data);
      });
    } else {
      setState(() {
        userId = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // wait until user ID is received
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _userIdReceived,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Getting user ID...'));
            } else if (asyncSnapshot.hasError) {
              return Center(child: Text(asyncSnapshot.error.toString()));
            } else {
              return ServerList(isDemo: isDemo);
            }
          },
        ),
      ),
    );
  }
}
