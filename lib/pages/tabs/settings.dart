import 'dart:convert';

import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../dio_client.dart';

class Settings extends StatefulWidget {
  final bool isDemo;

  const Settings({super.key, required this.isDemo});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _displayName = '';
  String _profilePic = '';

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserInfo() async {
    if (widget.isDemo) {
      _displayName = lang.demoName;
      _profilePic = '';
    } else {
      try {
        final response = await dioClient.dio.get(
          '/api/user/fetch',
          queryParameters: {'userID': 'self'},
        );

        final parsed = jsonDecode(response.data);
        // UserModel user = UserModel.fromJson(parsed);

        setState(() {
          _displayName = parsed['displayName'];
          _profilePic = parsed['picture'];
        });
      } on DioException catch (e) {
        debugPrint('$e');
        // setState(() {
        //   if (e.type == DioExceptionType.connectionError) {
        //     _loggedInText = serverOfflineText;
        //   } else if (e.type == DioExceptionType.badResponse) {
        //     _loggedInText = 'Not logged in!';
        //   } else {
        //     _loggedInText = e.type.toString();
        //   }
        // });
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: Center(
                  child: Avatar(
                    size: 128,
                    pic: _profilePic,
                    name: _displayName,
                  ),
                ),
              ),
            ),

            Text(_displayName, style: TextStyle(fontSize: 18)),
            ElevatedButton.icon(
              onPressed: () => {},
              icon: const Icon(Icons.edit),
              label: Text(lang.editProfile, style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
