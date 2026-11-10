import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/services/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageWrapper extends StatelessWidget {
  const ImageWrapper({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.progressIndicatorBuilder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
      imageUrl: imageUrl,
      httpHeaders: !kIsWeb ? getCachedTokenCookieHeader() : null,
      height: height,
      width: width,
      fit: fit,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorWidget: errorWidget,
    );
  }
}
