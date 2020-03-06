library online_world_map;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'map.dart';

class OWMapOptions {
  final String imageAsset;
  final Color mapColor;
  final Color bgColor;
  final double speed;
  final double maxPointRadius;
  final Color defaultPointColor;
  final Duration defaultPointTTL;

  OWMapOptions({
    this.imageAsset = 'packages/online_world_map/assets/world_map.png',
    this.mapColor = const Color(0xFFCDD0D7),
    this.bgColor = const Color(0xFFEEEEEE),
    this.speed,
    this.maxPointRadius = 4.0,
    this.defaultPointColor = Colors.blue,
    this.defaultPointTTL = Duration.zero,
  });
}

class OWMapContainer extends StatefulWidget {
  final OWMapOptions options;

  OWMapContainer({
    Key key,
    @required this.options,
  })  : assert(options != null),
        super(key: key);

  @override
  _OWMapContainerState createState() => _OWMapContainerState();
}

class _OWMapContainerState extends State<OWMapContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  OWMap _map;

  get map => _map;

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
//      animationBehavior: AnimationBehavior.preserve,
      duration: Duration(seconds: 1),
    )..repeat();

    _map = OWMap(
      animation: _animation,
      showSpeedRate: widget.options.speed,
      hideSpeedRate: widget.options.speed,
      maxPointRadius: widget.options.maxPointRadius,
      defaultPointColor: widget.options.defaultPointColor,
      defaultPointTTL: widget.options.defaultPointTTL,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }

//  void fakeData() {
//    assert(_map != null);
//    final List<OWMapPoint> points = []; // generatePoints(random.nextInt(1000));
//
////    points.add(OWMapPoint(
////      lat: -34.356586,
////      lng: 18.473981,
////      radius: 1.0,
////      color: Colors.red,
////      ttl: Duration(hours: 1),
////      fractionDigits: 5,
////    ));
//
//    points.add(OWMapPoint(
//      lat: 0.0,
//      lng: 0.0,
//      radius: 2.0,
//      color: Colors.black,
//      ttl: Duration(hours: 1),
//      fractionDigits: 5,
//    ));
//
//    _map.points = points;
//    _animation.addListener(() {
//      final sec = _animation.lastElapsedDuration.inSeconds;
//      if (sec > 3) {
//        final randMod = random.nextInt(100);
//        if (randMod == 0) return;
//        if (sec % randMod == 0) {
//          final points = generatePoints(random.nextInt(3));
//          if (points.length > 0) {
//            debugPrint('Point {ttl: ${points.first.ttl}}');
//            _map.points = points;
//          }
//        }
//      }
//    });
//  }
//
//  List<OWMapPoint> generatePoints(
//    int num, {
//    int maxTTL = 120,
//    Color color = Colors.blue,
//  }) {
//    return List.generate(num, (index) {
//      return OWMapPoint(
//        lat: random.nextDouble() * (random.nextBool() ? 80 : -50),
//        lng: random.nextDouble() * (random.nextBool() ? 180 : -180),
//        color: color,
//        ttl: Duration(seconds: random.nextInt(maxTTL)),
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Container(
      // TODO: refactory
      height: size * 0.72,
      width: size,
      color: widget.options.bgColor,
      padding: EdgeInsets.only(top: 10),
      child: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.cover,
        child: CustomPaint(
          foregroundPainter: _OWMapPainter(_map, _animation),
          child: Container(
            width: size,
            height: size,
            child: Image(
              image: AssetImage(widget.options.imageAsset),
              color: widget.options.mapColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _OWMapPainter extends CustomPainter {
  _OWMapPainter(this.map, this.animation)
      : assert(map != null),
        super(repaint: animation);

  final Animation animation;
  final OWMap map;

  @override
  void paint(Canvas canvas, Size size) => map.render(canvas, size);

  @override
  bool shouldRepaint(_OWMapPainter oldDelegate) =>
      map.points != oldDelegate.map.points;
}
