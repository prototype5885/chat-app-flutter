import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    _authFuture = checkIsLoggedIn();
  }

  Future<void> checkIsLoggedIn() async {
    await dio.get('/api/v1/test_auth');
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/chat',
        arguments: {'demo': false},
      );
    }
  }

  void _retry() {
    setState(() {
      _authFuture = checkIsLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _authFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Checking if logged in...'));
          } else if (asyncSnapshot.hasError) {
            final error = asyncSnapshot.error;

            // show login registration buttons if no token was found
            if (error is DioException && error.response?.statusCode == 401) {
              return _loginRegisterWidget();
            }

            // show if unexpected error,
            // which should only be that server isn't running
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${asyncSnapshot.error.toString()}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            '/chat',
            arguments: {'demo': true},
          );
        },
        label: const Text('Demo'),
      ),
    );
  }

  Widget _loginRegisterWidget() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16.0,
            children: [
              const Text(
                'Hallo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: const Text('Registration'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
