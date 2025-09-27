import 'package:chat_app_flutter/globals.dart';
import 'package:chat_app_flutter/language.dart';
import 'package:chat_app_flutter/pages/login.dart';
import 'package:chat_app_flutter/pages/register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _loggedInText = lang.loading;

  @override
  void initState() {
    super.initState();
    _isLoggedIn();
  }

  Future<void> _isLoggedIn() async {
    await dioClient.init();

    try {
      await dioClient.dio.get('/api/auth/isLoggedIn');
      setState(() {
        _loggedInText = lang.loggedIn;
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage(isDemo: false)),
      );
    } on DioException catch (e) {
      debugPrint('$e');
      setState(() {
        if (e.type == DioExceptionType.connectionError) {
          _loggedInText = lang.serverOffline;
        } else if (e.type == DioExceptionType.badResponse) {
          _loggedInText = lang.notLoggedIn;
        } else {
          _loggedInText = e.type.toString();
        }
      });
    } catch (e) {
      debugPrint('$e');
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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

                  const SizedBox(height: 64.0),

                  ElevatedButton(
                    onPressed: _isLoggedIn,
                    child: Text(_loggedInText, style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 32.0),

                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                    },
                    child: Text(lang.login, style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      ),
                    },
                    child: Text(lang.register, style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(isDemo: true),
                        ),
                      ),
                    },
                    child: Text(lang.demo, style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
