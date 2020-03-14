import 'dart:math';

import 'package:flutter/material.dart';

class OWMapController {
  OWMapController({
    this.mapWidth = 2048,
    this.mapHeight = 2048,
    this.longitudeLeft = -180,
    this.longitudeRight = 180,
    this.offsetEquator = 236,
    this.offsetPrimeMeridian = -62,
    this.showSpeedRate = 0.9,
    this.hideSpeedRate = 0.9,
    this.maxPointRadius = 4.0,
    this.defaultPointColor,
    this.defaultPointTTL,
  });

  final int mapWidth;
  final int mapHeight;
  final int longitudeLeft;
  final int longitudeRight;
  final int offsetEquator;
  final int offsetPrimeMeridian;
  final double showSpeedRate;
  final double hideSpeedRate;
  final double maxPointRadius;
  final Color defaultPointColor;
  final Duration defaultPointTTL;

  AnimationController _animation;

  int _lastTimeMs = 0;

  List<OWMapPoint> _points;

  List<OWMapPoint> get points => _points;

  set animation(AnimationController animation) => _animation = animation;

  /// Add [points] to the map
  ///
  set points(List<OWMapPoint> points) {
    if (_points == null) {
      _points = points.map((p) {
        p.state = OWMapPointState.active;
        return p;
      }).toList();
    } else {
      _points.addAll(points);
    }
    _points = _points.toSet().toList();
  }

  /// Clear the map
  ///
  void clear() {
    _points.clear();
  }

  /// This method render [points] on the [canvas]
  /// based on the [size].
  ///
  void render(Canvas canvas, Size size) {
    if (_animation == null || _points == null || _points.length == 0) {
      return;
    }

    final Paint paint = Paint();

    final double delta =
        (_animation.lastElapsedDuration.inMilliseconds - _lastTimeMs) /
            Duration.millisecondsPerSecond;

    _lastTimeMs = _animation.lastElapsedDuration.inMilliseconds;

    _points.removeWhere((point) => point.state == OWMapPointState.inactive);

    for (OWMapPoint point in _points) {
      if (_updatePoint(point, delta)) {
        canvas.drawCircle(
          _pointOffset(point, size),
          point.targetRadius,
          paint..color = point.targetColor.withOpacity(point.opacity),
        );

        /// Generate [point] shadow effect
        if (point.state == OWMapPointState.showing) {
          canvas.drawCircle(
            _pointOffset(point, size),
            point.targetRadius * 1.5, // TODO: config
            paint..color = point.targetColor.withOpacity(0.3),
          );
        }
      }
    }
  }

  /// This method updates the [point] when [render] was called.
  ///
  bool _updatePoint(OWMapPoint point, double delta) {
    switch (point.state) {
      case OWMapPointState.idle:
        point.opacity = 1.0;
        point.targetRadius = maxPointRadius;
        if (defaultPointColor != null) {
          point.color = defaultPointColor;
        }
        if (point.targetColor == null) {
          point.targetColor = point.color;
        }
        if (point.ttl == Duration.zero && defaultPointTTL != null) {
          point.ttl = defaultPointTTL;
        }
        point.state = OWMapPointState.showing;
        continue showing;
        break;
      showing:
      case OWMapPointState.showing:
        point.targetColor =
            Color.lerp(point.targetColor, point.color, delta * showSpeedRate);
        point.targetRadius -= delta * showSpeedRate;
        if (point.targetRadius <= point.radius) {
          point.state = OWMapPointState.active;
          continue active;
        }
        break;
      active:
      case OWMapPointState.active:
        point.opacity = 1.0;
        point.targetRadius = point.radius;
        point.targetColor = point.color;
        if (point.ttl < _animation.lastElapsedDuration) {
          point.state = OWMapPointState.hiding;
          continue hiding;
        }
        break;
      hiding:
      case OWMapPointState.hiding:
        //        point.opacity = lerpDouble(point.opacity, 0.0, hideSpeed);
        point.opacity -= delta * hideSpeedRate;
        if (point.opacity <= 0.0) {
          point.state = OWMapPointState.inactive;
          point.opacity = 0.0;
          continue inactive;
        }
        break;
      inactive:
      case OWMapPointState.inactive:
        return false;
        break;
    }

    return true;
  }

  /// This method converts the [point] coordinates
  /// to map offset representation.
  ///
  Offset _pointOffset(OWMapPoint point, Size size) {
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

enum OWMapPointState {
  idle,
  showing,
  hiding,
  active,
  inactive,
}

class OWMapPoint {
  OWMapPoint({
    this.lat = 0.0,
    this.lng = 0.0,
    this.radius = 1.0,
    this.opacity = 1.0,
    this.color = Colors.black54,
    this.ttl = Duration.zero,
    this.state = OWMapPointState.idle,
    this.fractionDigits = 1,
  })  : assert(lat != null),
        assert(lng != null);

  double lat;
  double lng;
  double radius;
  double targetRadius = 1.0;
  double opacity;
  Color color;
  Color targetColor;
  Duration ttl;
  OWMapPointState state;

  /// Optimize render for a large number of points.
  ///
  int fractionDigits;

  @override
  String toString() {
    return '$runtimeType {lat: $lat, lng: $lng, radius: $radius, color: $color}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is OWMapPoint &&
        lat.toStringAsFixed(fractionDigits) ==
            other.lat.toStringAsFixed(fractionDigits) &&
        lng.toStringAsFixed(fractionDigits) ==
            other.lng.toStringAsFixed(fractionDigits);
  }

  @override
  int get hashCode {
    return lat.toStringAsFixed(fractionDigits).hashCode ^
        lng.toStringAsFixed(fractionDigits).hashCode ^
        radius.hashCode;
  }
}
