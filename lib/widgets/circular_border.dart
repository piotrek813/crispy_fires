import 'dart:math';

import 'package:flutter/material.dart';

class CircularBorder extends StatelessWidget {
  final Color color;
  final double width;
  final double borderWidth;
  final Widget child;

  const CircularBorder(
      {super.key,
      required this.color,
      required this.width,
      required this.borderWidth,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
          CustomPaint(
            size: Size(width, width),
            foregroundPainter: CircularBorderPainter(
                completeColor: color, borderWidth: borderWidth),
          ),
        ],
      ),
    );
  }
}

class CircularBorderPainter extends CustomPainter {
  Color lineColor = Colors.transparent;
  Color completeColor;
  double borderWidth;
  CircularBorderPainter(
      {required this.completeColor, required this.borderWidth});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = Paint()
      ..color = completeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - borderWidth / 2;
    var percent = (size.width * 0.001) / 2;

    double arcAngle = 2 * pi * percent;

    for (var i = 0; i < 8; i++) {
      var init = (-pi / 2) * (i / 2);

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), init,
          arcAngle, false, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
