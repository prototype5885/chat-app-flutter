import 'package:flutter/material.dart';

final current = ValueNotifier<Decoration>(darker());

Decoration diskord() {
  return BoxDecoration(color: Color.fromRGBO(66, 68, 75, 1));
}

Decoration darker() {
  return BoxDecoration(color: Color.fromRGBO(53, 54, 60, 1));
}

Decoration gradient1() {
  return BoxDecoration(
    color: Colors.blueAccent,
    gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Colors.purpleAccent, Colors.blueAccent, Colors.pinkAccent],
      stops: [0.0, 0.5, 1.0],
    ),
  );
}
