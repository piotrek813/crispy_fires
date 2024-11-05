import 'package:flutter/material.dart';

class PlayerPhoto extends StatelessWidget {
  const PlayerPhoto({
    super.key,
    this.radius,
    required this.name,
  });

  final double? radius;
  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: radius,
      backgroundImage:
          NetworkImage("https://api.dicebear.com/9.x/personas/png?seed=$name"),
    );
  }
}
