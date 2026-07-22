import 'package:chat_app_flutter/services/globals.dart';
import 'package:chat_app_flutter/widgets/network_image.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GestureDetector(
        onTap: pressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ClipOval(
            child: Container(
              color: colorScheme.primaryContainer,
              width: size,
              height: size,
              child: ClipOval(
                child: pic != null
                    ? ImageWrapper(
                        imageUrl: backend
                            .replace(
                              path: "/avatars/$pic",
                              queryParameters: {'size': '80'},
                            )
                            .toString(),

                        fit: BoxFit.cover,
                        width: size,
                        height: size,
                        errorWidget: (context, url, error) => _noPicture(),
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
    return const Center(child: Icon(Icons.person));
  }
}
