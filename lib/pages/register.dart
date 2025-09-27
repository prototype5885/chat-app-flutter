import 'package:chat_app_flutter/language.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstPasswordController =
      TextEditingController();
  final TextEditingController _secondPasswordController =
      TextEditingController();

  // bool _passwordsMatch = true;
  String _errorMessages = 'error1\nerror2';

  @override
  void initState() {
    super.initState();
    // _firstPasswordController.addListener(_comparePasswords);
    // _secondPasswordController.addListener(_comparePasswords);
  }

  void _register() {
    String email = _emailController.text;
    String firstPassword = _firstPasswordController.text;
    String secondPassword = _secondPasswordController.text;
  }

  // void _comparePasswords() {
  //   print('First password: ${_firstPasswordController.text}');
  //   print('Second password: ${_secondPasswordController.text}');
  //   setState(() {
  //     _passwordsMatch =
  //         _firstPasswordController.text == _secondPasswordController.text;
  //   });
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _firstPasswordController.dispose();
    _secondPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang.register)),
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
                    lang.register,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    controller: _firstPasswordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: lang.password,
                      hintText: lang.enterPassword,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  TextField(
                    controller: _secondPasswordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: lang.passwordAgain,
                      hintText: lang.enterPasswordAgain,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  Text(_errorMessages, style: TextStyle(color: Colors.red)),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: _register,
                    child: Text(lang.register, style: TextStyle(fontSize: 18)),
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
