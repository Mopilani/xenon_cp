import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

final Paint black = Paint()
  ..color = Colors.white
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke;

class TrimPathPainter extends CustomPainter {
  TrimPathPainter(
    this.percent,
    this.origin,
    this.path, {
    required this.id,
  });

  final String id;
  final double percent;
  final PathTrimOrigin origin;
  final Path path;

  @override
  bool shouldRepaint(TrimPathPainter oldDelegate) =>
      oldDelegate.percent != percent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, black);
  }
}
