// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

class ClockPaint extends CustomPainter {
  ClockPaint({required this.now});
  DateTime now;
  @override
  void paint(Canvas canvas, Size size) {
    Paint bgClockPaint = Paint()..color = Color(0x0DFFFFFF);
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, bgClockPaint);

    Paint whiteRingOffSetBrush = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, whiteRingOffSetBrush);

    // draw the sec min and hour hand

    //1. hrs Brush
    double hrsHandX =
        centerX + 65 * cos((now.hour * 30 + now.minute * 0.5) * pi / 180);
    double hrsHandY =
        centerY + 65 * sin((now.hour * 30 + now.minute * 0.5) * pi / 180);
    Paint hrsBrush = Paint()
      ..color = Colors.pink.shade200
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(hrsHandX, hrsHandY), hrsBrush);

    //2. min Brush
    double minHandX = centerX + 75 * cos(now.minute * 6 * pi / 180);
    double minHandY = centerY + 75 * sin(now.minute * 6 * pi / 180);
    Paint minBrush = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(minHandX, minHandY), minBrush);

    //3. sec Brush
    double secHandX = centerX + 85 * cos(now.second * 6 * pi / 180);
    double secHandY = centerY + 85 * sin(now.second * 6 * pi / 180);
    Paint secBrush = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(secHandX, secHandY), secBrush);

    //draw the center
    Paint centerBrush = Paint()..color = Color(0xFFFFFFFF);

    canvas.drawCircle(center, 10, centerBrush);

    //draw hour dash
    Paint dashBrush = Paint()..color = Color(0xFFFFFFFF);
    for (var i = 0; i < 360; i += 30) {
      double x1 = centerX + (radius + 16) * cos(i * pi / 180);
      double y1 = centerY + (radius + 16) * sin(i * pi / 180);
      double x2 = centerX + (radius + 10) * cos(i * pi / 180);
      double y2 = centerY + (radius + 10) * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
