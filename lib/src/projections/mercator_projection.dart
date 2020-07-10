import 'dart:math';
import 'dart:ui';

import '../point.dart';
import 'projection.dart';

class MercatorProjection implements SimpleMapProjection {
  final int mapWidth;
  final int mapHeight;
  final int longitudeLeft;
  final int longitudeRight;
  final int offsetEquator;
  final int offsetPrimeMeridian;

  const MercatorProjection({
    this.mapWidth = 2048,
    this.mapHeight = 2048,
    this.longitudeLeft = -180,
    this.longitudeRight = 180,
    this.offsetEquator = 236,
    this.offsetPrimeMeridian = -62,
  });

  Offset project(SimpleMapPoint point, Size size) {
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
}
