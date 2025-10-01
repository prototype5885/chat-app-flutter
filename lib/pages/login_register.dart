import 'package:chat_app_flutter/pages/register.dart';
import 'package:flutter/material.dart';

import '../language.dart';
import 'login.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 250),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: <Widget>[
          FilledButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ),
            },
            child: Text(lang.login, style: TextStyle(fontSize: 18)),
          ),

          FilledButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              ),
            },
            child: Text(lang.register, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
