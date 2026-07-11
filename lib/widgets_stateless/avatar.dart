import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/services/cookies.dart';
import 'package:chat_app_flutter/services/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String? pic;
  final String name;
  final VoidCallback? pressed;

  const Avatar({
    super.key,
    required this.size,
    required this.pic,
    required this.name,
    this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: pressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: ClipOval(
                child: pic != null
                    ? CachedNetworkImage(
                        imageUrl: backend
                            .replace(
                              path: "/avatars/$pic",
                              queryParameters: {'size': '80'},
                            )
                            .toString(),

                        httpHeaders: !kIsWeb ? getTokenCookieHeader() : null,
                        fit: BoxFit.cover,
                        width: size,
                        height: size,
                      )
                    : _noPicture(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noPicture() {
    if (name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Text(
        name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: size / 3,
        ),
      ),
    );
  }
}
