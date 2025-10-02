import 'package:flutter/material.dart';
import 'dart:async';

class DelayedLoadingIndicator extends StatefulWidget {
  const DelayedLoadingIndicator({super.key});

  @override
  State<DelayedLoadingIndicator> createState() =>
      _DelayedLoadingIndicatorState();
}

class _DelayedLoadingIndicatorState extends State<DelayedLoadingIndicator> {
  bool show = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          show = true;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (show) {
      return const CircularProgressIndicator();
    } else {
      return const SizedBox.shrink();
    }
  }
}
