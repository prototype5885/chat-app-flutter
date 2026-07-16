import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/routes/chat.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
    });

    try {
      await dio.post(
        '/api/v1/user/login',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Chat(isDemo: false)),
        );
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response!.data.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.login)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 26,
              children: [
                Text(
                  loc.login,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                Column(
                  spacing: 16,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: loc.username,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: loc.password,
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text(loc.login),
                  ),
                ),
                Center(
                  child: Text(loc.forgotPassword, textAlign: TextAlign.center),
                ),
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
