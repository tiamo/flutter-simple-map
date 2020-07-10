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
    this.color = Colors.black54,
    this.ttl = Duration.zero,
    this.state = SimpleMapPointState.idle,
    this.fractionDigits = 1,
  })  : assert(lat != null),
        assert(lng != null);

  double lat;
  double lng;
  double radius;
  double targetRadius = 1.0;
  double opacity;
  Color color;
  Color targetColor;
  Duration ttl;
  SimpleMapPointState state;

  /// Optimize render for a large number of points.
  ///
  int fractionDigits;

  @override
  String toString() {
    return '$runtimeType {lat: $lat, lng: $lng, radius: $radius, color: $color}';
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
