import 'dart:convert';

import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

import '../dio_client.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String displayName = '';
  late String profilePic = '';

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
    if (state.demo.value) {
      setState(() {
        displayName = lang.demoName;
        profilePic = '';
      });
    } else {
      try {
        final response = await dioClient.dio.get(
          '/api/user/fetch',
          queryParameters: {'userID': 'self'},
        );

        final parsed = jsonDecode(response.data);
        // UserModel user = UserModel.fromJson(parsed);

        setState(() {
          displayName = parsed['displayName'];
          profilePic = parsed['picture'];
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
                  child: Avatar(size: 128, pic: profilePic, name: displayName),
                ),
              ),
            ),

            Text(displayName, style: TextStyle(fontSize: 18)),
            FilledButton.icon(
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
