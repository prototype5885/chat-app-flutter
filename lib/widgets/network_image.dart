import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/services/cookies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageWrapper extends StatefulWidget {
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
  State<ImageWrapper> createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = getTokenCookie();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        return CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 0),
          fadeOutDuration: const Duration(milliseconds: 0),
          imageUrl: widget.imageUrl,
          httpHeaders: !kIsWeb ? tokenToHeader(asyncSnapshot.data!) : null,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          progressIndicatorBuilder: widget.progressIndicatorBuilder,
          errorWidget: widget.errorWidget,
        );
      },
    );
  }
}
