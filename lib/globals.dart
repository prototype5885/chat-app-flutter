library;

import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;

final _backendAddress = !kIsWeb && Platform.isAndroid
    ? "10.0.2.2:3000"
    : '127.0.0.1:3000';

final backendHttpAddress = "http://$_backendAddress";
final backendWsAddress = "ws://$_backendAddress/ws";

const hoverBG = Color.fromRGBO(255, 255, 255, 0.05);
