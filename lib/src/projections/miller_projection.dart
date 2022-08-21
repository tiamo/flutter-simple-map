import 'dart:math';
import 'dart:ui';

import 'projection.dart';

class MillerProjection implements SimpleMapProjection {
  const MillerProjection({
    this.mapWidth = 1080,
    this.mapHeight = 1080,
    this.offsetPrimeMeridian = -105,
    this.offsetEquator = 200,
  });

  final int mapWidth;
  final int mapHeight;
  final int offsetEquator;
  final int offsetPrimeMeridian;

  dynamic _toRadian(v) {
    return (v * pi) / 180;
  }

  @override
  Offset project(double? lat, double? lng, Size? size) {
    final scale = mapWidth / pi / 2;
    final ratio = size!.width / mapWidth;

    final double latRad = _toRadian(lat);
    final double lngRad = _toRadian(lng);

    var x = lngRad;
    var y = -1.25 * log(tan(pi / 4 + 0.4 * latRad));

    x *= scale;
    y *= scale;

    x += (mapWidth / 2) + offsetPrimeMeridian;
    y += (mapHeight / 2) + offsetEquator;

    x *= ratio;
    y *= ratio;

    return Offset(x, y);
  }
}
