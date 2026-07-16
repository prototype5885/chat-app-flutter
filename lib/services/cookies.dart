import 'dart:io';

import 'package:chat_app_flutter/services/globals.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

late final PersistCookieJar cookieJar;
String? cachedToken;

Future<void> setupCookieJar() async {
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
  }
}

Future<String?> getTokenCookie() async {
  List<Cookie> cookies = await cookieJar.loadForRequest(backend);

  for (var cookie in cookies) {
    if (cookie.name == 'token') {
      return cookie.value;
    }
  }

  return null;
}

Map<String, String> tokenToHeader(String? token) {
  if (token != null) {
    return {'Cookie': 'token=$token;'};
  } else {
    // TODO handle this better
    return {};
  }
}
