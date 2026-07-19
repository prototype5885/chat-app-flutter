import 'dart:io';

import 'package:chat_app_flutter/services/globals.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

late final PersistCookieJar _cookieJar;
late final Dio dio;

String? _cachedToken;

class SetCookieInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final setCookies = response.headers['set-cookie'];
    if (setCookies != null) {
      for (final raw in setCookies) {
        final cookie = Cookie.fromSetCookieValue(raw);
        if (cookie.name == 'token') {
          _cachedToken = cookie.value;
        }
      }
    }
    handler.next(response);
  }
}

Future<void> setupDioClient() async {
  dio = Dio();
  dio.options.baseUrl = backend.toString();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  // allow accepting/sending cookies through cors
  if (cors && kIsWeb) {
    dio.options.extra['withCredentials'] = true;
  }

  if (!kIsWeb) {
    dio.interceptors.add(CookieManager(_cookieJar));
    dio.interceptors.add(SetCookieInterceptor());
  }
}

Future<void> setupCookieJar() async {
  // save cookies into a file if not running on web browser
  if (!kIsWeb) {
    final docDir = await getApplicationDocumentsDirectory();
    final dir = '${docDir.path}/ChatApp/.cookies/';

    final cookiesDir = Directory(dir);
    if (!await cookiesDir.exists()) {
      await cookiesDir.create(recursive: true);
    }

    _cookieJar = PersistCookieJar(storage: FileStorage(dir));

    // cache the token cookie value initially from disk using cookie jar
    List<Cookie> cookies = await _cookieJar.loadForRequest(backend);
    for (var cookie in cookies) {
      if (cookie.name == 'token') {
        _cachedToken = cookie.value;
      }
    }
  }
}

String? getCachedToken() {
  return _cachedToken;
}

Map<String, String> getCachedTokenCookieHeader() {
  return _cachedToken != null ? {'Cookie': 'token=$_cachedToken;'} : {};
}

// Future<void> connectSSE() async {
//   final response = await dio.get(
//     '/api/v1/session',
//     options: Options(
//       responseType: ResponseType.stream,
//       receiveTimeout: Duration.zero,
//       headers: {'Accept': 'text/event-stream', 'Cache-Control': 'no-cache'},
//     ),
//   );

//   final stream = response.data!.stream;
//   final buffer = StringBuffer();

//   await for (final chunk in stream) {
//     buffer.write(utf8.decode(chunk));
//     final blocks = buffer.toString().split('\n\n');

//     buffer.clear();
//     buffer.write(blocks.removeLast());

//     for (final block in blocks) {
//       if (block.trim().isEmpty) continue;

//       String event = "";
//       String data = "";

//       for (final line in block.split('\n')) {
//         if (line.startsWith('event:')) {
//           event = line.substring(6).trim();
//         } else if (line.startsWith('data:')) {
//           data = line.substring(5).trim();
//         }
//       }

//       events.emit(event, data);
//     }
//   }

//   throw Exception('SSE stream closed');
// }
