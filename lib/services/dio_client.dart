import 'dart:io';

import 'package:chat_app_flutter/services/globals.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

late final Dio dio;
late final PersistCookieJar cookieJar;
String? cachedToken;

Future<void> setupDioClient() async {
  dio = Dio();
  dio.options.baseUrl = backend.toString();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  // allow accepting/sending cookies through cors
  if (cors && kIsWeb) {
    dio.options.extra['withCredentials'] = true;
  }

  // save cookies into a file if not running on web browser
  if (!kIsWeb) {
    final docDir = await getApplicationDocumentsDirectory();
    final dir = '${docDir.path}/ChatApp/.cookies/';

    final cookiesDir = Directory(dir);
    if (!await cookiesDir.exists()) {
      await cookiesDir.create(recursive: true);
    }

    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(dir),
    );

    dio.interceptors.add(CookieManager(cookieJar));

    List<Cookie> cookies = await cookieJar.loadForRequest(backend);

    for (var cookie in cookies) {
      if (cookie.name == 'token') {
        cachedToken = cookie.value;
        break;
      }
    }
  }
}

Future<String?> getCookieValue(String name) async {
  List<Cookie> cookies = await cookieJar.loadForRequest(backend);

  for (var cookie in cookies) {
    if (cookie.name == name) {
      return cookie.value;
    }
  }

  return null;
}

Map<String, String> getTokenCookieHeader() {
  return {'Cookie': 'token=$cachedToken!;'};
}
