import 'package:flutter/material.dart';

enum SimpleMapPointState {
  idle,
  showing,
  hiding,
  active,
  inactive,
}

mixin SimpleMapPointAnimator {
  void render({
    required SimpleMapPoint point,
    required Animation<double> animation,
    required Canvas canvas,
    required Offset center,
  });
}

class SimpleMapPoint {
  SimpleMapPoint({
    this.lat = 0.0,
    this.lng = 0.0,
    this.radius = 1.0,
    this.opacity = 1.0,
    this.color,
    this.ttl = Duration.zero,
    this.state = SimpleMapPointState.idle,
    this.fractionDigits = 1,

    /// Point showing effect animator
    this.animator,
  });

  final double lat;
  double lng;
  double radius;
  double targetRadius = 1.0;
  double opacity;
  Color? color;
  Color? targetColor;
  Duration? ttl;
  SimpleMapPointState state;
  SimpleMapPointAnimator? animator;

  ///
  /// Optimize render for a large number of points.
  ///
  int fractionDigits;

  @override
  String toString() {
    return '$runtimeType {state: $state, lat: $lat, lng: $lng, radius: $radius, targetRadius: $targetRadius, color: $color, ttl: $ttl}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SimpleMapPoint &&
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
