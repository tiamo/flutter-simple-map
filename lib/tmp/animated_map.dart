//import 'dart:async';
//import 'dart:ui';
//
//import 'package:flutter/material.dart';
//import 'package:threesixteen/assets.dart';
//
//import '../map.dart';
//
//// The default map tween animation duration.
//const Duration _kDuration = Duration(milliseconds: 700);
//
//const Color _kPaintColor = Colors.blue;
//
//class AnimatedLiveMap extends StatefulWidget {
//  const AnimatedLiveMap({
//    Key key,
//    @required this.initialData,
//    this.duration = _kDuration,
//    this.showAntarctica = false,
//    this.pointColor = _kPaintColor,
//  }) : super(key: key);
//
//  final List<LiveMapLayerEntry> initialData;
//  final bool showAntarctica;
//  final Color pointColor;
//
//  /// is called.
//  final Duration duration;
//
//  /// The state from the closest instance of this class that encloses the given context.
//  ///
//  /// This method is typically used by [AnimatedLiveMap] item widgets that insert or
//  /// remove items in response to user input.
//  ///
//  /// ```dart
//  /// AnimatedLiveMapState animatedLiveMap = AnimatedLiveMap.of(context);
//  /// ```
//  static AnimatedLiveMapState of(BuildContext context, {bool nullOk: false}) {
//    assert(context != null);
//    assert(nullOk != null);
//
//    final AnimatedLiveMapState result =
//        context.ancestorStateOfType(TypeMatcher<AnimatedLiveMapState>());
//
//    if (nullOk || result != null) return result;
//
//    throw new FlutterError(
//        'AnimatedLiveMap.of() called with a context that does not contain a AnimatedLiveMap.\n'
//        'No AnimatedLiveMap ancestor could be found starting from the context that was passed to AnimatedLiveMap.of(). '
//        'This can happen when the context provided is from the same StatefulWidget that '
//        'built the AnimatedCircularChart.\n'
//        'The context used was:\n'
//        '  $context');
//  }
//
//  @override
//  AnimatedLiveMapState createState() => AnimatedLiveMapState();
//}
//
//class AnimatedLiveMapState extends State<AnimatedLiveMap>
//    with TickerProviderStateMixin {
//  AnimationController _animation;
//  LiveMapTween _tween;
//  Timer timer;
//
//  final Map<String, int> _layerRanks = <String, int>{};
//  final Map<String, int> _pointRanks = <String, int>{};
//
//  var scaleAnimation;
//
//  @override
//  void initState() {
//    super.initState();
//
//    _animation = AnimationController(
//      duration: widget.duration,
//      vsync: this,
//    );
//
//    _assignRanks(widget.initialData);
//
//    _tween = LiveMapTween(
//      LiveMap.empty(),
//      LiveMap.fromData(
//        data: widget.initialData,
//        pointColor: widget.pointColor,
//        layerRanks: _layerRanks,
//        pointRanks: _pointRanks,
//      ),
//    );
//
////    _animation.addStatusListener((status) {
////      if (status == AnimationStatus.completed)
////        _animation.reverse();
////      else if (status == AnimationStatus.dismissed) _animation.forward();
////    });
////
////    _animation.forward();
//  }
//
////  @override
////  void didUpdateWidget(AnimatedLiveMap oldWidget) {
////    super.didUpdateWidget(oldWidget);
////    if (widget.initialData != oldWidget.initialData) {
////      _updateLabelPainter();
////    }
////  }
////
////  @override
////  void didChangeDependencies() {
////    super.didChangeDependencies();
////    _updateLabelPainter();
////  }
//
//  @override
//  void dispose() {
//    _animation.dispose();
//    timer?.cancel();
//    super.dispose();
//  }
//
//  void _assignRanks(List<LiveMapLayerEntry> data) {
//    for (LiveMapLayerEntry layerEntry in data) {
//      _layerRanks.putIfAbsent(layerEntry.rankKey, () => _layerRanks.length);
//      for (LiveMapPointEntry entry in layerEntry.points) {
//        _pointRanks.putIfAbsent(entry.rankKey, () => _pointRanks.length);
//      }
//    }
//  }
//
//  /// Update the data this map represents and start an animation that will tween
//  /// between the old data and this one.
//  void updateData(List<LiveMapLayerEntry> data) {
//    _assignRanks(data);
//
//    setState(() {
//      _tween = LiveMapTween(
//        _tween.evaluate(_animation),
//        LiveMap.fromData(
//          data: data,
//          layerRanks: _layerRanks,
//          pointRanks: _pointRanks,
//        ),
//      );
//      _animation.forward(from: 0.0);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//
//    AssetImage image = AssetImage(ImageAssets.worldMap);
//
//    return Container(
////    return CustomPaint(
////      foregroundPainter: AnimatedLiveMapPainter(_tween.animate(_animation)),
//      child: Container(
//        width: size.width,
//        height: size.width,
//        alignment: Alignment.topCenter,
//        //              child: CustomPaint(
//        //                foregroundPainter:
//        //                    AnimatedLiveMapPainter(_tween.animate(_animation)),
////        child: Container(
////          // always square
////          width: size.width,
////          height: size.width,
////          Image(image: image, color: Color(0xFFE4F0FE))
//        child: Image(image: image, color: Color(0xFFCDD0D7)),
////        ),
//        //              ),
//      ),
//    );
//  }
//}
