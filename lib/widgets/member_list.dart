import 'package:chat_app_flutter/widgets/top.dart';
import 'package:flutter/material.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 265,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Top(childWidget: Text('members')),
          Column(children: [Text('Member 1'), Text('Member 2')]),
        ],
      ),
    );
  }
}
