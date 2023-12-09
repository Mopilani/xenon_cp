import 'package:flutter/material.dart';

class StateDescripe extends StatelessWidget {
  const StateDescripe({Key? key, required this.name, required this.color})
      : super(key: key);
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 7,
          backgroundColor: color,
        ),
        const SizedBox(width: 4),
        Text(name),
      ],
    );
  }
}
