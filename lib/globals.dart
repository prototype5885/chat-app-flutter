library;

import 'package:chat_app_flutter/dio_client.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

final DioClient dioClient = DioClient();

final String backendAddress = !kIsWeb && Platform.isAndroid
    ? "http://10.0.2.2:3000"
    : 'http://127.0.0.1:3000';
