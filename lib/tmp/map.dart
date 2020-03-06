import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'entry.dart';
import 'map_layer.dart';
import 'tween.dart';

class LiveMap {
  // TODO: other params
  LiveMap(this.layers);

  final List<LiveMapLayer> layers;

  factory LiveMap.empty() {
    return LiveMap(<LiveMapLayer>[]);
  }

  factory LiveMap.fromData({
    @required List<LiveMapLayerEntry> data,
    Color pointColor, // TODO: ...
    Map<String, int> layerRanks,
    Map<String, int> pointRanks,
  }) {
    List<LiveMapLayer> layers = List<LiveMapLayer>.generate(
      data.length,
      (i) => LiveMapLayer.fromData(
        layerRanks[data[i].rankKey] ?? i,
        data[i].points,
        pointRanks,
      ),
    );

    return LiveMap(layers);
  }
}

class LiveMapTween extends Tween<LiveMap> {
  LiveMapTween(LiveMap begin, LiveMap end)
      : _layersTween = MergeTween<LiveMapLayer>(begin.layers, end.layers),
        super(begin: begin, end: end);

  final MergeTween<LiveMapLayer> _layersTween;

  @override
  LiveMap lerp(double t) => LiveMap(_layersTween.lerp(t));
}
