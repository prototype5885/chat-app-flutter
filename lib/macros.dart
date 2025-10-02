import 'package:chat_app_flutter/pages/chat.dart';
import 'package:chat_app_flutter/pages/chat_mobile_wrapper.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/widgets/error_icon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SnowflakeDateFormat { short, medium, long }

int optimizeImageCache(double size, BuildContext context) {
  return (size * MediaQuery.of(context).devicePixelRatio).toInt();
}

void openChat(BuildContext context, bool demo) {
  state.demo.value = demo;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          state.mobile.value ? const ChatMobileWrapper() : const Chat(),
    ),
  );
}

Widget handleError(Object? error) {
  if (error is DioException) {
    return ErrorIcon(text: error.response!.statusMessage.toString());
  } else {
    return ErrorIcon(text: error.toString());
  }
}

String extractDate(String id, SnowflakeDateFormat format) {
  final BigInt bigId = BigInt.parse(id);
  final BigInt timestamp = bigId >> 22;
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());

  String pattern;

  switch (format) {
    case SnowflakeDateFormat.short:
      pattern = 'H:mm';
      break;
    case SnowflakeDateFormat.medium:
      pattern = 'MMMM d, y';
      break;
    case SnowflakeDateFormat.long:
      pattern = 'MMMM d, y HH:mm';
      break;
  }

  return DateFormat(pattern).format(date);
}
