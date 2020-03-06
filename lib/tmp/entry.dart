import 'dart:ui';

/// Data object defining a layer in a map.
///
/// A stack is composed of [entries], a List containing 1 or more [LiveMapPointEntry]
/// and an optional [rankKey] String.
class LiveMapLayerEntry {
  const LiveMapLayerEntry(this.points, {this.rankKey});

  /// List of [LiveMapPointEntry]s that make up this stack.
  final List<LiveMapPointEntry> points;

  /// An optional String key, used when animating maps to preserve semantics when
  /// transitioning between data points.
  final String rankKey;
}

class LiveMapPointEntry {
  const LiveMapPointEntry(this.lat, this.lng, this.radius, this.color,
      {this.rankKey});

  final double lat;
  final double lng;
  final double radius;
  final Color color;

  /// An optional String key, used when animating maps to preserve semantics when
  /// transitioning between data points.
  final String rankKey;
}
