import 'package:chat_app_flutter/pages/chat.dart';
import 'package:chat_app_flutter/pages/chat_mobile_wrapper.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/widgets/error_icon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
