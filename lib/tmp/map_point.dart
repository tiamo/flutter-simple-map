import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'tween.dart';

class LiveMapPoint implements MergeTweenable<LiveMapPoint> {
  final double lat;
  final double lng;
  final double radius;
  final Color color;

  /// An optional String key, used when animating map points to preserve semantics when
  /// transitioning between data points.
  final int rank;

  LiveMapPoint(this.rank, this.lat, this.lng, this.radius, this.color);

  // TODO: radius 0 ?
  @override
  LiveMapPoint get empty => LiveMapPoint(rank, lat, lng, radius, color.withOpacity(0));

  @override
  bool operator <(LiveMapPoint other) => rank < other.rank;

  @override
  Tween<LiveMapPoint> tweenTo(LiveMapPoint other) => MapPointTween(this, other);

  static LiveMapPoint lerp(LiveMapPoint begin, LiveMapPoint end, double t) {
    assert(begin.rank == end.rank);
    return LiveMapPoint(
      begin.rank,
      begin.lat,
      begin.lng,
      lerpDouble(begin.radius, end.radius, t),
      Color.lerp(begin.color, end.color, t),
    );
  }

  @override
  String toString() {
    return "{ rank: $rank, lat: $lat, lng: $lng, radius: $radius, color: $color }";
  }
}

class MapPointTween extends Tween<LiveMapPoint> {
  MapPointTween(LiveMapPoint begin, LiveMapPoint end) : super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  @override
  LiveMapPoint lerp(double t) => LiveMapPoint.lerp(begin, end, t);
}
