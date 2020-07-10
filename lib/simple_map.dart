library simple_map;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'src/controller.dart';
import 'src/options.dart';

export 'src/controller.dart';
export 'src/options.dart';
export 'src/point.dart';
export 'src/projections/mercator_projection.dart';
export 'src/projections/projection.dart';

class SimpleMap extends StatefulWidget {
  final SimpleMapOptions options;
  final SimpleMapController controller;

  SimpleMap({
    Key key,
    @required this.options,
    @required this.controller,
  })  : assert(options != null),
        assert(controller != null),
        super(key: key);

  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    widget.controller.animation = _animation;

    if (widget.options.projection != null) {
      widget.controller.projection = widget.options.projection;
    }

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
          foregroundPainter: _SimpleMapPainter(widget.controller, _animation),
          child: Container(
            width: size,
            height: size,
            child: Image(
              image: AssetImage(widget.options.mapAsset),
              color: widget.options.mapColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleMapPainter extends CustomPainter {
  _SimpleMapPainter(this.controller, this.animation)
      : assert(controller != null),
        super(repaint: animation);

  final Animation animation;
  final SimpleMapController controller;

  @override
  void paint(Canvas canvas, Size size) => controller.render(canvas, size);

  @override
  bool shouldRepaint(_SimpleMapPainter oldDelegate) =>
      controller.points != oldDelegate.controller.points;
}
