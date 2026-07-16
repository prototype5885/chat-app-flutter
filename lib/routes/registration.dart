import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:chat_app_flutter/routes/chat.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerAgain = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordControllerAgain.dispose();
    super.dispose();
  }

  Future<void> _register(AppLocalizations loc) async {
    setState(() {
      _errorMessage = '';
    });

    if (_passwordController.text != _passwordControllerAgain.text) {
      setState(() {
        _errorMessage = loc.passwordsDontMatch;
      });
      return;
    }

    try {
      await dio.post(
        '/api/v1/user/register',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

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
      appBar: AppBar(title: Text(loc.registration)),
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
                  loc.registration,
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
                    TextField(
                      controller: _passwordControllerAgain,
                      decoration: InputDecoration(
                        labelText: loc.passwordRepeat,
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
                      _register(loc);
                    },
                    child: Text(loc.register),
                  ),
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
