import 'package:material_ui/material_ui.dart';

class Hashtag extends StatelessWidget {
  const new({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(-0.2),
      child: Icon(Icons.tag, color: color),
    );
  }
}
