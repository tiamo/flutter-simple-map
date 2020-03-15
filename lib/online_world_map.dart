library online_world_map;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'map.dart';

class OWMapOptions {
  final String imageAsset;
  final Color mapColor;
  final Color bgColor;

  OWMapOptions({
    this.imageAsset = 'packages/online_world_map/assets/world_map.png',
    this.mapColor = const Color(0xFFCDD0D7),
    this.bgColor = Colors.transparent,
  });
}

class OWMap extends StatefulWidget {
  final OWMapOptions options;
  final OWMapController controller;

  OWMap({
    Key key,
    @required this.options,
    @required this.controller,
  })  : assert(options != null),
        assert(controller != null),
        super(key: key);

  @override
  _OWMapState createState() => _OWMapState();
}

class _OWMapState extends State<OWMap> with SingleTickerProviderStateMixin {
  AnimationController _animation;

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    widget.controller.animation = _animation;

    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.clear();
    _animation?.dispose();
    super.dispose();
  }

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
          foregroundPainter: _OWMapPainter(widget.controller, _animation),
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
  _OWMapPainter(this.controller, this.animation)
      : assert(controller != null),
        super(repaint: animation);

  final Animation animation;
  final OWMapController controller;

  @override
  void paint(Canvas canvas, Size size) => controller.render(canvas, size);

  @override
  bool shouldRepaint(_OWMapPainter oldDelegate) =>
      controller.points != oldDelegate.controller.points;
}
