import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'globals.dart';

class DioClient {
  final Dio dio = Dio();

  Future<void> init() async {
    dio.options.baseUrl = backendAddress;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final cookiePath = '${directory.path}/chatapp/.cookies/';

      final cookieDir = Directory(cookiePath);
      if (!await cookieDir.exists()) {
        await cookieDir.create(recursive: true);
      }

      final cookieJar = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage(cookiePath),
      );

      dio.interceptors.add(CookieManager(cookieJar));
    }
  }
}
