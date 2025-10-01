import 'dart:developer';

import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/login_register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/state.dart' as state;

import '../dio_client.dart';
import '../macros.dart' as macros;

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late Future<void> loading;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.mobile.value = MediaQuery.of(context).size.width < 600;
    });

    loading = isLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> isLoggedIn() async {
    await dioClient.init();

    log("Checking if is logged in already...");
    await dioClient.dio.get('/api/auth/isLoggedIn');

    if (!mounted) return;
    macros.openChat(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FutureBuilder(
              future: loading,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  final error = asyncSnapshot.error;
                  String displayStatusText;

                  if (error is DioException) {
                    if (error.type == DioExceptionType.connectionError) {
                      displayStatusText = lang.serverOffline;
                    } else if (error.type == DioExceptionType.badResponse) {
                      displayStatusText = lang.notLoggedIn;
                      return LoginRegister();
                    } else {
                      displayStatusText = "Error: ${error.type}";
                    }
                  } else {
                    displayStatusText = "Error: $error";
                  }

                  return Text(
                    displayStatusText,
                    style: TextStyle(fontSize: 24),
                  );
                } else {
                  return Text("Success!");
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () => macros.openChat(context, true),
          child: Text(lang.demo),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
