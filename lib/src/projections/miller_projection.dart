import 'dart:math';
import 'dart:ui';

import '../point.dart';
import 'projection.dart';

class MillerProjection implements SimpleMapProjection {
  final int mapWidth;
  final int mapHeight;
  final int offsetEquator;
  final int offsetPrimeMeridian;

  const MillerProjection({
    this.mapWidth = 1080,
    this.mapHeight = 1080,
    this.offsetEquator = -200,
    this.offsetPrimeMeridian = -36,
  });

  _toRadian(v) {
    return (v * pi) / 180;
  }

  Offset project(SimpleMapPoint point, Size size) {
    double scale = mapWidth / pi / 2;
    double ratio = size.width / mapWidth;

    double lat = _toRadian(point.lat);
    double lng = _toRadian(point.lng);

    double x = lng;
    double y = -1.25 * log(tan(pi / 4 + 0.4 * lat));

    x *= scale;
    y *= scale;

    x += (mapWidth / 2) + offsetPrimeMeridian;
    y += (mapHeight / 2) + offsetEquator;

    x *= ratio;
    y *= ratio;

    return Offset(x, y);
  }
}
