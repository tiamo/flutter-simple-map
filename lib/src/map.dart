import 'package:flutter/material.dart';

// import 'package:shimmer/shimmer.dart';

import 'controller.dart';
import 'marker.dart';
import 'options.dart';
import 'utils.dart';

const _kDefaultDuration = Duration(seconds: 1);

class SimpleMap extends StatefulWidget {
  const SimpleMap({
    Key? key,
    required this.options,
    required this.controller,
  }) : super(key: key);

  final SimpleMapOptions options;
  final SimpleMapController controller;

  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _pointAnimation;
  AnimationController? _transformAnimation;

  Widget? _mapIcon;
  double? _size;

  @override
  void initState() {
    if (widget.options.interactive) {
      _pointAnimation = AnimationController(
        vsync: this,
        duration: _kDefaultDuration,
        debugLabel: 'SimpleMap.points',
      );
      _pointAnimation!.repeat();
    }

    _transformAnimation = AnimationController(
      vsync: this,
      debugLabel: 'SimpleMap.transform',
    );

    widget.controller.configure(
      state: this,
      options: widget.options,
      animation: _pointAnimation,
      transformAnimation: _transformAnimation,
    );

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _pointAnimation?.dispose();
    _transformAnimation?.dispose();
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.controller.startAnimation();
        break;
      case AppLifecycleState.paused:
        widget.controller.stopAnimation();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_size != constraints.maxWidth) {
          _size = constraints.maxWidth;
          _mapIcon ??= _buildMap(constraints.maxWidth);
          widget.controller.size = Size.square(constraints.maxWidth);
        }

        Widget mapIcon = _mapIcon!;

        // if (widget.controller.isBusy) {
        //   mapIcon = Shimmer.fromColors(
        //     baseColor: widget.options.mapColor,
        //     highlightColor: ColorHelper.lighten(widget.options.mapColor, 0.2),
        //     enabled: true,
        //     child: _mapIcon,
        //   );
        // }

        // mapIcon = Offstage(offstage: true, child: mapIcon);

        Widget map = FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.loose,
            children: [
              CustomPaint(
                foregroundPainter: _SimpleMapPainter(
                  widget.controller,
                  _pointAnimation,
                ),
                child: mapIcon,
              ),
              ..._buildMarkers()
            ],
          ),
        );

        if (_transformAnimation != null) {
          map = AnimatedBuilder(
            animation: _transformAnimation!,
            builder: (ctx, map) {
              return Transform.scale(
                scale: widget.controller.zoom,
                child: FractionalTranslation(
                  translation: widget.controller.translation,
                  child: map,
                ),
              );
            },
            child: map,
          );
        }

        return ColoredBox(
          color: widget.options.bgColor,
          child: map,
        );
      },
    );
  }

  Widget _buildMap(double size) {
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
            text: String.fromCharCode(widget.options.mapIcon.codePoint),
            style: TextStyle(
              inherit: false,
              color: widget.options.mapColor,
              fontSize: size / 2,
              height: 1.0,
              fontFamily: widget.options.mapIcon.fontFamily,
              package: widget.options.mapIcon.fontPackage,
              shadows: widget.options.withShadow
                  ? [
                      Shadow(
                        color: ColorHelper.darken(
                          widget.options.mapColor,
                          0.12,
                        ),
                        offset: widget.options.shadowOffset,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMarkers() {
    return widget.controller.markers.map((m) {
      final offset = widget.controller.project(m.lat, m.lng);
      return widget.options.markerBuilder != null
          ? widget.options.markerBuilder!(m, offset)
          : defaultMarkerBuilder(m, offset);
    }).toList();
  }
}

class _SimpleMapPainter extends CustomPainter {
  const _SimpleMapPainter(
    this.controller,
    this.animation,
  ) : super(repaint: animation);

  final Animation? animation;
  final SimpleMapController controller;

  @override
  void paint(Canvas canvas, Size size) => controller.render(canvas, size);

  @override
  bool shouldRepaint(_SimpleMapPainter oldDelegate) =>
      true; // !identical(this, oldDelegate);
}
