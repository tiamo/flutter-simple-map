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

  /// Map projection
  final SimpleMapProjection projection;

  /// Map's vector representation based on [IconData]
  final IconData mapIcon;

  /// The color of the map
  final Color mapColor;

  /// The color of the map canvas
  final Color bgColor;

  /// The color of the map's point
  final Color? pointColor;

  /// The start color of the map's point animation
  final Color? startPointColor;

  /// Marker builder
  final Widget Function(SimpleMapMarker, Offset)? markerBuilder;

  /// 3D effect (based on map shadow)
  final bool withShadow;

  /// The map's shadow offset
  final Offset shadowOffset;

  /// Enable map animation
  final bool interactive;
}
