import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:simple_map/simple_map.dart';

import 'projections/miller_projection.dart';
import 'projections/projection.dart';

class SimpleMapController {
  SimpleMapController({
    this.showSpeedRate = 0.4,
    this.hideSpeedRate = 0.9,
    this.maxPointRadius = 4.0,
    this.shadowRatio = 1.5,
    this.shadowOpacity = 0.3,
    this.defaultPointTTL,
    this.radiusScaleFactors,
    this.glowRadius = 0.0,
    points,
  }) : _points = points;

  final double showSpeedRate;
  final double hideSpeedRate;
  final double maxPointRadius;
  final double shadowRatio;
  final double shadowOpacity;
  final Duration? defaultPointTTL;
  final double glowRadius;

  /// pointsSize > radiusFactor
  final Map<int, double>? radiusScaleFactors;

  double initialZoom = 1.0;
  Curve curve = Curves.linear;

  final List<SimpleMapMarker> _markers = [];
  List<SimpleMapPoint>? _points;
  Color? _defaultPointColor;
  Color? _startPointColor;
  int _lastTimeMs = 0;
  double _maxZoom = 0.0;

  Offset? _tCenter;
  double _tZoom = 0.0;
  Size _size = Size.zero;
  State<SimpleMap>? _state;

  Animation<Offset>? _centerAnim;
  Animation<Offset>? _offsetAnim;
  Animation<double>? _zoomAnim;
  AnimationController? _animation;
  AnimationController? _transformAnimation;

  SimpleMapProjection _projection = const MillerProjection();

  ///
  /// Get active points list
  ///
  List<SimpleMapPoint>? get points => _points;

  ///
  /// Get active markers list
  ///
  List<SimpleMapMarker> get markers => _markers;

  bool get isBusy => false;
  double get zoom => _zoomAnim?.value ?? initialZoom;
  Offset get center => _centerAnim?.value ?? Offset.zero;
  Offset get translation => _offsetAnim?.value ?? Offset.zero;

  // ignore: avoid_setters_without_getters
  set size(Size size) => _size = size;

  ///
  /// Add list of [points] to the map
  ///
  set points(List<SimpleMapPoint>? points) {
    final tmp = points!.map((p) {
      if (p.color == null && _defaultPointColor != null) {
        p.color = _defaultPointColor;
      }
      p.targetRadius = maxPointRadius;
      if (_points == null) {
        p.state = SimpleMapPointState.active;
      }
      return p;
    }).toList();
    if (_points == null) {
      _points = tmp;
    } else {
      _points!.addAll(tmp);
    }
  }

  ///
  /// Add new [point] to the map
  ///
  void addPoint(SimpleMapPoint point) {
    if (point.color == null && _defaultPointColor != null) {
      point.color = _defaultPointColor;
    }
    point.targetRadius = maxPointRadius;
    if (_points == null) {
      _points = [point];
    } else {
      _points!.add(point);
    }
  }

  void addMarker(SimpleMapMarker marker) {
    _markers.add(marker);
    // TODO: refactory
    // ignore: invalid_use_of_protected_member
    _state?.setState(() {});
  }

  bool removeMarker(SimpleMapMarker marker) {
    if (_markers.remove(marker)) {
      // TODO: refactory
      // ignore: invalid_use_of_protected_member
      _state?.setState(() {});
    }
    return false;
  }

  void clearMarkers() {
    _markers.clear();
  }

  Offset project(double? lat, double? lng) {
    return _projection.project(lat, lng, _size);
  }

  ///
  /// Fly animation to the new [lat] and [lng]
  ///
  Future<void> flyTo(
    double? lat,
    double? lng, {
    double zoom = 10,
    Duration duration = const Duration(milliseconds: 1500),
  }) async {
    _tZoom = min(_maxZoom, zoom);
    _tCenter = project(lat, lng);
    _updateAnim();
    if (_transformAnimation != null) {
      // await _transformAnimation.animateBack(
      //   0.5,
      //   duration: duration ?? const Duration(milliseconds: 500),
      // );
      // _transformAnimation.reset();
      await _transformAnimation!.animateTo(1.0, duration: duration);
    }
  }

  void _updateAnim() {
    if (_transformAnimation == null || _tCenter == null) {
      return;
    }

    _centerAnim = Tween<Offset>(begin: project(0, 0), end: _tCenter).animate(
      CurvedAnimation(
        parent: _transformAnimation!,
        curve: Curves.ease,
      ),
    );

    _offsetAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        0.5 - _tCenter!.dx / _size.width,
        0.5 - _tCenter!.dy / _size.height,
      ),
    ).animate(CurvedAnimation(
      parent: _transformAnimation!,
      curve: Curves.ease,
    ));

    // TODO: refactory
    _zoomAnim = Tween<double>(begin: initialZoom, end: _tZoom).animate(
      CurvedAnimation(
        parent: _transformAnimation!,
        curve: Curves.ease,
      ),
    );
  }

  ///
  /// Configure
  ///
  void configure({
    required SimpleMapOptions options,
    Animation? animation,
    Animation? transformAnimation,
    State<SimpleMap>? state,
  }) {
    _state = state;
    _maxZoom = options.maxZoom;
    _defaultPointColor = options.pointColor ?? _defaultPointColor;
    _startPointColor = options.startPointColor ?? _startPointColor;
    _projection = options.projection;
    _animation = animation as AnimationController? ?? _animation;
    _transformAnimation =
        transformAnimation as AnimationController? ?? _transformAnimation;
  }

  ///
  /// Clear the map
  ///
  void clear() {
    debugPrint('[$runtimeType] Clear points');
    if (_points != null) {
      _points!.clear();
    }
    _markers.clear();
  }

  void stopAnimation() {
    if (_animation != null && _animation!.isAnimating) {
      _animation?.stop();
    }
    if (_points != null) {
      _points!.removeWhere((p) => p.state != SimpleMapPointState.active);
    }
  }

  void startAnimation() {
    if (_animation != null && !_animation!.isAnimating) {
      _animation!.repeat();
    }
  }

  double _interpolateWithEasing(double min, double max, double t) {
    final lerp = (t - min) / (max - min);
    return lerp;
    // return Curves.easeIn.transform(lerp);
  }

  ///
  /// Calculate point radius scale factor
  ///
  get _pointRadiusScaleFactor {
    double pointRadiusScaleFactor = 1.0;
    if (radiusScaleFactors?.isNotEmpty == true) {
      radiusScaleFactors!.forEach((sizeFrom, scaleFactor) {
        if (_points!.length >= sizeFrom) {
          pointRadiusScaleFactor = scaleFactor;
        }
      });
    }
    if (pointRadiusScaleFactor <= 0) {
      pointRadiusScaleFactor = 1.0;
    }
    return pointRadiusScaleFactor;
  }

  ///
  /// This method render [points] on the [canvas]
  /// based on the [size].
  ///
  void render(Canvas canvas, Size size) {
    if (_state == null) {
      throw Exception('Please use `controller.configure` before render.');
    }

    var delta = 0.0;
    if (_animation != null) {
      final _newLastTimeMs =
          _animation!.lastElapsedDuration?.inMilliseconds ?? 0;
      delta = (_newLastTimeMs - _lastTimeMs) / Duration.millisecondsPerSecond;
      _lastTimeMs = _newLastTimeMs;
    }

    if (_points == null || _points!.isEmpty) {
      return;
    }

    final paint = Paint();

    _points!.removeWhere(
      (point) => point.state == SimpleMapPointState.inactive,
    );

    // print(_points!.where((element) => element.state != SimpleMapPointState.active));

    for (final point in _points!) {
      // TODO: refactory
      final animation = AlwaysStoppedAnimation(
        max(
          0.0,
          1.0 - _interpolateWithEasing(0.0, maxPointRadius, point.targetRadius),
        ),
      );

      if (_updatePoint(point, delta, animation.value)) {
        if (point.targetColor == null) {
          continue;
        }

        final center = _projection.project(point.lat, point.lng, size);
        if (center.dx.isNaN || center.dy.isNaN) {
          continue;
        }

        final pointRadius = point.radius * _pointRadiusScaleFactor;

        // if (point.state == SimpleMapPointState.showing) {
        //   radius = point.targetRadius;
        // }

        final radius = point.targetRadius > maxPointRadius
            ? pointRadius
            : point.targetRadius * _pointRadiusScaleFactor;

        final color = point.targetColor!.withOpacity(
          point.opacity.toDouble().clamp(0.0, 1.0),
        );

        canvas.drawCircle(center, radius, paint..color = color);

        if (glowRadius > 0) {
          canvas.drawShadow(
            Path()
              ..addOval(
                Rect.fromCircle(
                  center: center.translate(0, -glowRadius),
                  radius: radius,
                ),
              ),
            color,
            glowRadius,
            false,
          );
        }

        // disabled animation
        if (_animation == null) {
          continue;
        }

        /// Generate [point] shadow effect
        ///
        // if (point.state == SimpleMapPointState.showing || point.state == SimpleMapPointState.active) {
        if (point.state == SimpleMapPointState.showing) {
          if (point.animator != null) {
            point.animator!.render(
              point: point,
              animation: animation,
              canvas: canvas,
              center: center,
            );
          } else if (shadowRatio > 0) {
            // Default point animator
            // var radius = point.targetRadius * shadowRatio;
            // var rect = Rect.fromCircle(center: center, radius: radius);
            final radius = Tween(
              begin: 0.0,
              end: min(point.targetRadius * shadowRatio, pointRadius * 5),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
              ),
            );
            final opacity = Tween(begin: shadowOpacity, end: 0.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
              ),
            );

            canvas.drawCircle(
              center,
              radius.value,
              paint..color = point.targetColor!.withOpacity(opacity.value),
            );
          }
        }
      }
    }
  }

  ///
  /// This method updates the [point] when [render] was called.
  ///
  bool _updatePoint(SimpleMapPoint point, double delta, double t) {
    switch (point.state) {
      case SimpleMapPointState.idle:
        point.opacity = 1.0;
        point.targetRadius = maxPointRadius;
        point.targetColor = _startPointColor ?? point.color;
        if (point.ttl == Duration.zero && defaultPointTTL != null) {
          point.ttl = defaultPointTTL;
        }
        if (_animation?.lastElapsedDuration != null) {
          point.ttl = Duration(
            milliseconds: _animation!.lastElapsedDuration!.inMilliseconds +
                point.ttl!.inMilliseconds,
          );
        }
        point.state = SimpleMapPointState.showing;
        continue showing;
      showing:
      case SimpleMapPointState.showing:
        point.targetColor = Color.lerp(
          _startPointColor ?? point.color,
          point.color ?? _defaultPointColor,
          t,
        );
        point.targetRadius -= delta * showSpeedRate;
        // if (point.targetRadius <= point.radius) {
        if (point.targetRadius <= 0) {
          point.state = SimpleMapPointState.active;
          continue active;
        }
        break;
      active:
      case SimpleMapPointState.active:
        point.opacity = 1.0;
        point.targetRadius = point.radius;
        point.targetColor =
            point.color ?? _defaultPointColor; // TODO: is it need ?
        if (_animation?.lastElapsedDuration != null &&
            point.ttl! < _animation!.lastElapsedDuration!) {
          point.state = SimpleMapPointState.hiding;
          continue hiding;
        }
        break;
      hiding:
      case SimpleMapPointState.hiding:
        // point.opacity = lerpDouble(point.opacity, 0.0, hideSpeed);
        point.opacity -= delta * hideSpeedRate;
        if (point.opacity <= 0.0) {
          point
            ..state = SimpleMapPointState.inactive
            ..opacity = 0.0;
          continue inactive;
        }
        break;
      inactive:
      case SimpleMapPointState.inactive:
        return false;
    }

    return true;
  }
}
