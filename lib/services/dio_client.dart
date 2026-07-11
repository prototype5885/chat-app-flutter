import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

late final Dio dio;

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
    dio.interceptors.add(CookieManager(cookieJar));
  }
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
