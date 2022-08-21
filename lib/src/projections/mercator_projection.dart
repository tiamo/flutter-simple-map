import 'dart:math';
import 'dart:ui';

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

  @override
  Offset project(double? lat, double? lng, Size? size) {
    final ratio = size!.width / mapWidth;
    final latRad = (lat! * pi) / 180;

    final g = log(tan(pi / 4 + latRad / 2));
    final lonOffset = longitudeRight - longitudeLeft;

    var dx = (lng! - longitudeLeft) * (mapWidth / lonOffset);
    var dy = mapHeight / 2 - (mapHeight * g) / (2 * pi);

    dx += offsetPrimeMeridian;
    dy += offsetEquator;

    dx *= ratio;
    dy *= ratio;

    return Offset(dx, dy);
  }
}
