import 'package:flutter/material.dart';

enum SimpleMapPointState {
  idle,
  showing,
  hiding,
  active,
  inactive,
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
    this.animator,
  });

  /// Point `latitude` coordinate
  final double lat;

  /// Point `longitude` coordinate
  final double lng;

  /// Point radius
  double radius;

  /// Point radius used in animation
  double targetRadius = 1.0;

  /// Point opacity
  double opacity;

  /// Point color
  Color? color;

  /// Point color used in animation
  Color? targetColor;

  /// Point time to live [Duration]
  Duration? ttl;

  /// Point state
  SimpleMapPointState state;

  /// Point showing effect animator
  final SimpleMapPointAnimator? animator;

  /// Optimize render for a large number of points.
  final int fractionDigits;

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

///
/// Point render animator used in animation
///
abstract class SimpleMapPointAnimator {
  void render({
    required SimpleMapPoint point,
    required Animation<double> animation,
    required Canvas canvas,
    required Offset center,
  });
}
