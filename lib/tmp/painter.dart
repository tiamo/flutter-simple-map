import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import 'map.dart';
import 'map_layer.dart';
import 'map_point.dart';

// TODO: config
final int mapWidth = 2048;
final int mapHeight = 2048;
final int longitudeLeft = -180;
final int longitudeRight = 180;
final int offsetPrimeMeridian = -62;
final int offsetEquator = 236;

class AnimatedLiveMapPainter extends CustomPainter {
  AnimatedLiveMapPainter(this.animation) : super(repaint: animation);

  final Animation<LiveMap> animation;

  @override
  void paint(Canvas canvas, Size size) {
    _paintMap(canvas, size, animation.value);
  }

  @override
  bool shouldRepaint(AnimatedLiveMapPainter old) => false;
}

class LiveMapPainter extends CustomPainter {
  LiveMapPainter(this.map);

  final LiveMap map;

  @override
  void paint(Canvas canvas, Size size) {
    _paintMap(canvas, size, map);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void _paintMap(Canvas canvas, Size size, LiveMap map) {
  final Paint paint = new Paint()
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt;

  for (final LiveMapLayer layer in map.layers) {
    for (final LiveMapPoint point in layer.points) {
      paint.color = point.color;
//        segmentPaint.strokeWidth = point.width;

      canvas.drawCircle(
        _convertLatLng(point, size),
        point.radius,
        paint,
      );
    }
  }
}

// TODO: check bad data
Offset _convertLatLng(LiveMapPoint point, Size size) {
  double ratio = size.width / mapWidth;
  double latRad = (point.lat * pi) / 180;

  double g = log(tan(pi / 4 + latRad / 2));
  int lonOffset = longitudeRight - longitudeLeft;

  double dx = (point.lng - longitudeLeft) * (mapWidth / lonOffset);
  double dy = mapHeight / 2 - (mapHeight * g) / (2 * pi);

  dx += offsetPrimeMeridian;
  dy += offsetEquator;

  dx *= ratio;
  dy *= ratio;

  return Offset(dx, dy);
}
