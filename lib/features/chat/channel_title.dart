import 'package:material_ui/material_ui.dart';

class ChannelTitle extends StatelessWidget {
  const new({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
