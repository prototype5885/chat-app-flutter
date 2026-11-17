import 'package:material_ui/material_ui.dart';

class Hashtag extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(-0.2),
      child: const Icon(Icons.tag),
    );
    ;
  }
}
