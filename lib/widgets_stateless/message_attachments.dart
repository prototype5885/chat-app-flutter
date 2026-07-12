import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:chat_app_flutter/services/schemas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Attachments extends StatelessWidget {
  const Attachments({super.key, required this.attachments});
  final List<Attachment> attachments;

  static const imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'wbmp',
  };

  bool isImage(String name) {
    final ext = name.split('.').last.toLowerCase();
    return imageExtensions.contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: attachments.map((a) {
        final url = backend.replace(path: "/attachments/${a.file}").toString();

        if (isImage(a.name)) {
          return CachedNetworkImage(
            cacheKey: a.file,
            imageUrl: url,
            httpHeaders: !kIsWeb ? getTokenCookieHeader() : null,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
                  height: 256,
                  width: 256,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                ),

            height: 256,
            fit: BoxFit.fill,
            errorWidget: (context, url, error) {
              return _FileTile(a.name, url);
            },
          );
        } else {
          return _FileTile(a.name, url);
        }
      }).toList(),
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile(this.name, this.url);
  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        height: 48,
        width: 256,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
      ),
    );
  }
}
