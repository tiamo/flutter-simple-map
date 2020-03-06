import 'package:flutter/animation.dart';

import 'entry.dart';
import 'map_point.dart';
import 'tween.dart';

class LiveMapLayer implements MergeTweenable<LiveMapLayer> {
  LiveMapLayer(this.rank, this.points);

  final int rank;
  final List<LiveMapPoint> points;

  @override
  bool operator <(LiveMapLayer other) => rank < other.rank;

  factory LiveMapLayer.fromData(
    int layerRank,
    List<LiveMapPointEntry> entries,
    Map<String, int> pointRanks,
  ) {
    List<LiveMapPoint> points =
        List<LiveMapPoint>.generate(entries.length, (i) {
      int rank = pointRanks[entries[i].rankKey] ?? i;
      return LiveMapPoint(
        rank,
        entries[i].lat,
        entries[i].lng,
        entries[i].radius,
        entries[i].color,
      );
    });

    return LiveMapLayer(
      layerRank,
      points.reversed.toList(),
    );
  }

  @override
  LiveMapLayer get empty => LiveMapLayer(rank, <LiveMapPoint>[]);

  @override
  Tween<LiveMapLayer> tweenTo(LiveMapLayer other) =>
      new MapLayerTween(this, other);
}

class MapLayerTween extends Tween<LiveMapLayer> {
  final MergeTween<LiveMapPoint> _mapPointsTween;

  MapLayerTween(LiveMapLayer begin, LiveMapLayer end)
      : _mapPointsTween = MergeTween<LiveMapPoint>(begin.points, end.points),
        super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  @override
  LiveMapLayer lerp(double t) =>
      LiveMapLayer(begin.rank, _mapPointsTween.lerp(t));
}
