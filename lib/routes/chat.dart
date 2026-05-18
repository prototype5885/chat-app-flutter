import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:chat_app_flutter/widgets/server_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  late final String userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserID();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchUserID() async {
    try {
      final response = await dio.get('/api/v1/user_id');
      setState(() {
        userId = response.data.toString();
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // wait until user ID is received
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return const Scaffold(body: SafeArea(child: ServerList()));
    }
  }
}
