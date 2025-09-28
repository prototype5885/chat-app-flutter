import 'dart:developer';

import 'package:chat_app_flutter/language.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _passwordHidden = true;

  String _errorMessage = '';
  String _successMessages = '';

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
      _successMessages = '';
      _loading = true;
    });

    try {
      log("Logging in...");
      await dioClient.dio.post(
        '/api/auth/login',
        queryParameters: {'rememberMe': _rememberMe.toString()},
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _successMessages = lang.loginSuccess;
      });
    } on DioException catch (e) {
      setState(() {
        if (e.type == DioExceptionType.connectionError) {
          _errorMessage = lang.serverOffline;
        } else if (e.type == DioExceptionType.badResponse) {
          _errorMessage = lang.loginFail;
        } else {
          _errorMessage = '${e.type}';
        }
      });
    } catch (e) {
      debugPrint('$e');
    }

    setState(() {
      _loading = false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordHidden = !_passwordHidden;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang.login)),
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
                  Text(
                    lang.login,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: lang.email,
                      hintText: lang.enterEmail,
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  TextField(
                    controller: _passwordController,
                    obscureText: _passwordHidden,
                    decoration: InputDecoration(
                      labelText: lang.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      hintText: lang.enterPassword,
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  CheckboxListTile(
                    title: Text(lang.rememberMe),
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  const SizedBox(height: 16.0),

                  if (_errorMessage.isNotEmpty) ...[
                    Text(_errorMessage, style: TextStyle(color: Colors.red)),
                  ],

                  if (_successMessages.isNotEmpty) ...[
                    Text(
                      _successMessages,
                      style: TextStyle(color: Colors.green),
                    ),
                  ],

                  if (_errorMessage.isNotEmpty || _successMessages.isNotEmpty)
                    const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: Text(
                      _loading ? lang.loggingIn : lang.login,
                      style: TextStyle(fontSize: 18),
                    ),
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
