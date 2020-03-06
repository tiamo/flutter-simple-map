library live_world_map;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LiveWorldMapOptions {
  final String imageAsset;
  final Color mapColor;

  LiveWorldMapOptions({
    this.imageAsset = 'assets/world_1080x1080.png',
    this.mapColor,
  });
}

class LiveWorldMap extends StatefulWidget {
  final LiveWorldMapOptions options;

  LiveWorldMap({
    Key key,
//    this.points,
    this.options,
  })  : assert(options != null),
        super(key: key);

  @override
  _LiveWorldMapState createState() => _LiveWorldMapState();
}

class _LiveWorldMapState extends State<LiveWorldMap>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;

  LiveMap _map;

  static Random random = Random();

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: Duration(seconds: 1),
    )..repeat();

    _map = LiveMap(animation: _animation);

    fakeData();

    super.initState();
  }

  void fakeData() {
    assert(_map != null);
    final List<LiveMapPoint> points = generatePoints(random.nextInt(1000));
    _map.points = points;
    _animation.addListener(() {
      final sec = _animation.lastElapsedDuration.inSeconds;
      if (sec > 3) {
        final randMod = random.nextInt(100);
        if (randMod == 0) return;
        if (sec % randMod == 0) {
          final points = generatePoints(random.nextInt(3));
          if (points.length > 0) {
            debugPrint('Point {ttl: ${points.first.ttl}}');
            _map.points = points;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }

  List<LiveMapPoint> generatePoints(int num, {int maxTTL = 120}) {
    return List.generate(num, (index) {
      return LiveMapPoint(
        lat: random.nextDouble() * (random.nextBool() ? 80 : -50),
        lng: random.nextDouble() * (random.nextBool() ? 180 : -180),
//        radius: 1.5,
        color: Colors.red,
        ttl: Duration(seconds: random.nextInt(maxTTL)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomPaint(
      foregroundPainter: LiveMapPainter(_map, _animation),
      child: Container(
        width: size.width,
        height: size.width,
        child: Image(
          image:
              AssetImage(widget.options.imageAsset, package: 'live_world_map'),
          color: widget.options.mapColor,
        ),
      ),
    );
  }
}

/// Map container
///
class LiveMap {
  final int mapWidth;
  final int mapHeight;
  final int longitudeLeft;
  final int longitudeRight;
  final int offsetPrimeMeridian;
  final int offsetEquator;
  final AnimationController animation;

  LiveMap({
    @required this.animation,
    this.mapWidth = 2048,
    this.mapHeight = 2048,
    this.offsetEquator = 236,
    this.longitudeLeft = -180,
    this.longitudeRight = 180,
    this.offsetPrimeMeridian = -62,
  });

  List<LiveMapPoint> _points;
  int _lastTimeMs = 0;

  set points(List<LiveMapPoint> points) {
    if (_points == null) {
      print(points.length);

      _points = points.map((p) {
        p.state = LiveMapPointState.active;
        return p;
      }).toList();
    } else {
      _points.addAll(points);
    }
    _points = _points.toSet().toList();
  }

  paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    final double delta =
        (animation.lastElapsedDuration.inMilliseconds - _lastTimeMs) /
            Duration.millisecondsPerSecond;

    _lastTimeMs = animation.lastElapsedDuration.inMilliseconds;

    if (_points.length == 0) {
      return;
    }

    _points.removeWhere((point) => point.state == LiveMapPointState.inactive);

    for (LiveMapPoint point in _points) {
      if (_updatePoint(point, delta)) {
        canvas.drawCircle(
          _pointOffset(point, size),
          point.targetRadius,
          paint..color = point.targetColor.withOpacity(point.opacity),
        );
      }
    }
  }

  bool _updatePoint(LiveMapPoint point, double delta) {
    final double speedIn = delta * 0.9;
    final double speedOut = delta * 0.9;
    final double maxRadius = 4.0;

    switch (point.state) {
      case LiveMapPointState.pending:
        point.opacity = 1.0;
        point.targetRadius = maxRadius;
        point.state = LiveMapPointState.showing;
        continue showing;
        break;
      showing:
      case LiveMapPointState.showing:
        point.targetColor = Color.lerp(point.targetColor, point.color, speedIn);
        point.targetRadius -= speedIn;
        if (point.targetRadius <= point.radius) {
          point.targetRadius = point.radius;
          point.state = LiveMapPointState.active;
          continue active;
        }
        break;
      active:
      case LiveMapPointState.active:
        point.opacity = 1.0;
        if (point.ttl < animation.lastElapsedDuration) {
          point.state = LiveMapPointState.hiding;
          continue hiding;
        }
        break;
      hiding:
      case LiveMapPointState.hiding:
//        point.opacity = lerpDouble(point.opacity, 0.0, hideSpeed);
        point.opacity -= speedOut;
        if (point.opacity <= 0.0) {
          point.state = LiveMapPointState.inactive;
          point.opacity = 0.0;
          continue inactive;
        }
        break;
      inactive:
      case LiveMapPointState.inactive:
        return false;
        break;
    }

    return true;
  }

  /// Get [Offset] based on point lat and lng.
  ///
  Offset _pointOffset(LiveMapPoint point, Size size) {
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

enum LiveMapPointState { pending, showing, hiding, active, inactive }

///
///
class LiveMapPoint {
  LiveMapPoint({
    this.lat = 0.0,
    this.lng = 0.0,
    this.radius = 1.0,
    this.opacity = 1.0,
    this.color = Colors.blue,
    this.ttl = Duration.zero,
    this.state = LiveMapPointState.pending,
    this.fractionDigits = 1,
  })  : assert(lat != null),
        assert(lng != null);

  double lat;
  double lng;
  double radius;
  double targetRadius = 1.0;
  double opacity;
  Color color;
  Color targetColor = Colors.blue;
  Duration ttl;
  LiveMapPointState state;
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
    return other is LiveMapPoint &&
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

///
///
class LiveMapPainter extends CustomPainter {
  LiveMapPainter(this.map, this.animation)
      : assert(map != null),
        super(repaint: animation);

  final Animation animation;
  final LiveMap map;

  @override
  void paint(Canvas canvas, Size size) {
    map.paint(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
