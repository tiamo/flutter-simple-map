import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:simple_map/simple_map.dart';

class RayMapPointAnimator implements SimpleMapPointAnimator {
  @override
  void render({
    required SimpleMapPoint point,
    required Animation<double> animation,
    required Canvas canvas,
    required Offset center,
  }) {
    final height = Tween(
      begin: 0.0,
      end: 40.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 1.0, curve: Cubic(0.02, 2.0, 0.04, 1.0)),
      ),
    );

    final r = Rect.fromCenter(
      center: Offset(center.dx, center.dy - height.value / 2),
      width: point.targetRadius,
      height: height.value,
    );

    final color = point.targetColor ?? point.color ?? Color(0x0);

    canvas.drawRect(
      r,
      Paint()
        ..shader = ui.Gradient.linear(
          r.topCenter,
          r.bottomCenter,
          [
            color.withAlpha(0),
            color,
          ],
        ),
    );
  }
}
