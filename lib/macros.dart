import 'package:flutter/material.dart';

int optimizeImageCache(double size, BuildContext context) {
  return (size * MediaQuery.of(context).devicePixelRatio).toInt();
}
