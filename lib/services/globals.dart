import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Uri get backend {
  return kIsWeb
      ? Uri.parse(Uri.base.origin)
      : Uri(scheme: 'http', host: 'localhost', port: 1848);
}

const cors = true;

const defaultBorder = BorderSide(
  color: Color.fromRGBO(255, 255, 255, 0.05),
  width: 1,
);

Color getHoverColor(bool dark) {
  if (dark) {
    return const Color.fromRGBO(255, 255, 255, 0.05);
  }
  return const Color.fromRGBO(0, 0, 0, 0.08);
}

Color getSelectedColor(bool dark) {
  if (dark) {
    return const Color.fromRGBO(255, 255, 255, 0.08);
  }
  return const Color.fromRGBO(0, 0, 0, 0.15);
}
