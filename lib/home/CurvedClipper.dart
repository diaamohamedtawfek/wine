import 'package:flutter/material.dart';

class CurvedClipper extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {

    final double innerCircleRadius = 0.0;

    Path path = Path();
    path.lineTo(0, rect.height/2);
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 10, rect.height/2 + 50, rect.width, rect.height/2);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}