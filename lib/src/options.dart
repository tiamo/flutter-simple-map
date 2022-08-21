import 'package:flutter/widgets.dart';

import 'icon.dart';
import 'marker.dart';
import 'projections/miller_projection.dart';
import 'projections/projection.dart';

class SimpleMapOptions {
  const SimpleMapOptions({
    this.interactive = true,
    this.projection = const MillerProjection(
      offsetEquator: 77,
      offsetPrimeMeridian: -33,
    ),
    this.mapIcon = MapProjectionIcon.miller,
    this.mapColor = const Color(0xFFCDD0D7),
    this.bgColor = const Color(0x0),
    this.pointColor,
    this.startPointColor,
    this.withShadow = true,
    this.shadowOffset = const Offset(0.0, 0.5),
    this.markerBuilder,
  });

  final SimpleMapProjection projection;
  final IconData mapIcon;
  final Color mapColor;
  final Color bgColor;
  final Color? pointColor;
  final Color? startPointColor;
  final Widget Function(SimpleMapMarker, Offset)? markerBuilder;

  final bool interactive;

  /// 3D effect
  final bool withShadow;
  final Offset shadowOffset;
}
