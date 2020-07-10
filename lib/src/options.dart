import 'package:flutter/material.dart';

import 'projections/mercator_projection.dart';
import 'projections/projection.dart';

class SimpleMapOptions {
  final SimpleMapProjection projection;
  final String mapAsset;
  final Color mapColor;
  final Color bgColor;

  SimpleMapOptions({
    this.projection = const MercatorProjection(),
    this.mapAsset = 'packages/simple_map/assets/mercator.png',
    this.mapColor = const Color(0xFFCDD0D7),
    this.bgColor = Colors.transparent,
  });
}
