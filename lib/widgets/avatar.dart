import 'package:chat_app_flutter/globals.dart';
import 'package:chat_app_flutter/macros.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String pic;
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
                child: pic.isNotEmpty
                    ? Image.network(
                        '$backendHttpAddress/cdn/avatars/$pic',
                        fit: BoxFit.cover,
                        cacheWidth: optimizeImageCache(size, context),
                        cacheHeight: optimizeImageCache(size, context),
                        width: size,
                        height: size,
                        errorBuilder: (context, error, stackTrace) {
                          return _noPicture();
                        },
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
