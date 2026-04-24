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
    try {
      await dio.get('/api/v1/test_auth');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/chat');
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/auth');
        }
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
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
      body: Center(
        child: FutureBuilder(
          future: _authFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error.toString()}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Connect'),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
