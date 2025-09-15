import 'package:flutter/material.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
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
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80.0,
            height: double.infinity,
            color: Colors.black.withAlpha(45),
            child: Center(child: Text('servers')),
          ),
          Expanded(
            child: Center(
              child: Text('stuff', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
