import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/login.dart';
import 'package:chat_app_flutter/pages/register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio_client.dart';
import 'chat.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<void> _loading;
  int _attempt = 0;
  String _statusText = lang.loading;

  @override
  void initState() {
    super.initState();
    _loading = _isLoggedIn();
  }

  Future<void> _isLoggedIn() async {
    await dioClient.init();

    const retryDelay = Duration(seconds: 5);

    while (true) {
      try {
        await dioClient.dio.get('/api/auth/isLoggedIn');
        setState(() {
          _statusText = lang.loggedIn;
        });

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatPage(isDemo: false),
          ),
        );
        return;
      } catch (e) {
        debugPrint('$e');
        setState(() {
          if (e is DioException) {
            if (e.type == DioExceptionType.connectionError) {
              _statusText = lang.serverOffline;
            } else if (e.type == DioExceptionType.badResponse) {
              _statusText = lang.notLoggedIn;
            } else {
              _statusText = e.type.toString();
            }
          } else {
            _statusText = "$e";
          }
        });
        await Future.delayed(retryDelay);
      }
      setState(() {
        _attempt++;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FutureBuilder(
                future: _loading,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        spacing: 24,
                        children: [
                          CircularProgressIndicator(),
                          Text("$_statusText, attempt: $_attempt"),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'Willkommen!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ),
                          },
                          child: Text(
                            lang.login,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        // const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            ),
                          },
                          child: Text(
                            lang.register,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(isDemo: true),
              ),
            ),
          },
          child: Text(lang.demo),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
