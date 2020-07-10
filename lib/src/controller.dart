import 'package:flutter/material.dart';
import 'package:simple_map/simple_map.dart';

import 'point.dart';
import 'projections/projection.dart';

class SimpleMapController {
  SimpleMapController({
    this.showSpeedRate = 0.9,
    this.hideSpeedRate = 0.9,
    this.maxPointRadius = 4.0,
    this.defaultPointColor,
    this.defaultPointTTL,
    points,
  }) {
    _points = points;
  }

  final double showSpeedRate;
  final double hideSpeedRate;
  final double maxPointRadius;
  final Color defaultPointColor;
  final Duration defaultPointTTL;

  int _lastTimeMs = 0;

  List<SimpleMapPoint> _points;

  /// Get active [points]
  ///
  List<SimpleMapPoint> get points => _points;

  AnimationController _animation;

  set animation(AnimationController animation) => _animation = animation;

  SimpleMapProjection _projection = MercatorProjection();

  set projection(SimpleMapProjection projection) => _projection = projection;

  /// Add list of [points] to the map
  ///
  set points(List<SimpleMapPoint> points) {
    if (_points == null) {
      _points = points.map((p) {
        p.state = SimpleMapPointState.active;
        return p;
      }).toList();
    } else {
      _points.addAll(points);
    }
    _points = _points.toSet().toList();
  }

  /// Add new [point] to the map
  ///
  void addPoint(SimpleMapPoint point) {
    if (_points == null) {
      _points = [point];
    } else {
      _points.add(point);
    }
  }

  /// Clear the map
  ///
  void clear() {
    if (_points != null) {
      _points.clear();
    }
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

    _points.removeWhere((point) => point.state == SimpleMapPointState.inactive);

    for (SimpleMapPoint point in _points) {
      if (_updatePoint(point, delta)) {
        canvas.drawCircle(
          _projection.project(point, size),
          point.targetRadius,
          paint..color = point.targetColor.withOpacity(point.opacity),
        );

        /// Generate [point] shadow effect
        if (point.state == SimpleMapPointState.showing) {
          canvas.drawCircle(
            _projection.project(point, size),
            point.targetRadius * 1.5, // TODO: config
            paint..color = point.targetColor.withOpacity(0.3),
          );
        }
      }
    }
  }

  /// This method updates the [point] when [render] was called.
  ///
  bool _updatePoint(SimpleMapPoint point, double delta) {
    switch (point.state) {
      case SimpleMapPointState.idle:
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
        point.state = SimpleMapPointState.showing;
        continue showing;
        break;
      showing:
      case SimpleMapPointState.showing:
        point.targetColor =
            Color.lerp(point.targetColor, point.color, delta * showSpeedRate);
        point.targetRadius -= delta * showSpeedRate;
        if (point.targetRadius <= point.radius) {
          point.state = SimpleMapPointState.active;
          continue active;
        }
        break;
      active:
      case SimpleMapPointState.active:
        point.opacity = 1.0;
        point.targetRadius = point.radius;
        point.targetColor = point.color;
        if (point.ttl < _animation.lastElapsedDuration) {
          point.state = SimpleMapPointState.hiding;
          continue hiding;
        }
        break;
      hiding:
      case SimpleMapPointState.hiding:
        //        point.opacity = lerpDouble(point.opacity, 0.0, hideSpeed);
        point.opacity -= delta * hideSpeedRate;
        if (point.opacity <= 0.0) {
          point.state = SimpleMapPointState.inactive;
          point.opacity = 0.0;
          continue inactive;
        }
        break;
      inactive:
      case SimpleMapPointState.inactive:
        return false;
        break;
    }

    return true;
  }
}
