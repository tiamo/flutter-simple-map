import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:online_world_map/map.dart';
import 'package:online_world_map/online_world_map.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());
  Wakelock.enable();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online World Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static Random random = Random();

  OWMapController _mapController;

  Ticker _ticker;

  @override
  void initState() {
    _mapController = OWMapController();
//    generateRandomPoints(100);
    initRealtimeTicker();

    super.initState();
  }

  void initRealtimeTicker() {
    _ticker = createTicker((elapsed) {
      final sec = elapsed.inSeconds;
      if (sec > 3) {
        final randMod = random.nextInt(100);
        if (randMod == 0) return;
        if (sec % randMod == 0) {
          final points = generatePoints(
            random.nextInt(3),
            color: Colors.primaries[random.nextInt(Colors.primaries.length)],
          );
          if (points.length > 0) {
            debugPrint('Point {ttl: ${points.first.ttl}}');
            _mapController.points = points;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void generateRandomPoints(int num) {
    assert(_mapController != null);
    final List<OWMapPoint> points = generatePoints(random.nextInt(num));

//    points.add(OWMapPoint(
//      lat: -34.356586,
//      lng: 18.473981,
//      radius: 1.0,
//      color: Colors.red,
//      ttl: Duration(hours: 1),
//      fractionDigits: 5,
//    ));
//
//    points.add(OWMapPoint(
//      lat: 0.0,
//      lng: 0.0,
//      radius: 2.0,
//      color: Colors.black,
//      ttl: Duration(hours: 1),
//      fractionDigits: 5,
//    ));

    _mapController.points = points;
  }

  List<OWMapPoint> generatePoints(
    int num, {
    int maxTTL = 120,
    Color color = Colors.blue,
  }) {
    return List.generate(num, (index) {
      return OWMapPoint(
        lat: random.nextDouble() * (random.nextBool() ? 80 : -50),
        lng: random.nextDouble() * (random.nextBool() ? 180 : -180),
        color: color,
        ttl: Duration(seconds: random.nextInt(maxTTL)),
      );
    });
  }

  bool liveEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Map Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OWMap(
              controller: _mapController,
              options: OWMapOptions(),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Text("Realtime data"),
        Switch(
          value: liveEnabled,
          onChanged: (value) {
            if (value) {
              _ticker.start();
            } else {
              _ticker.stop();
            }
            setState(() {
              liveEnabled = value;
            });
          },
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generateRandomPoints(random.nextInt(10));
        },
        tooltip: 'Add random points',
        child: Icon(Icons.add),
      ),
    );
  }

//  void fakeData() {
//    assert(_map != null);
//    final List<OWMapPoint> points = []; // generatePoints(random.nextInt(1000));
//
//    points.add(OWMapPoint(
//      lat: 0.0,
//      lng: 0.0,
//      radius: 2.0,
//      color: Colors.black,
//      ttl: Duration(hours: 1),
//      fractionDigits: 5,
//    ));
//
//    _map.points = points;
//    _animation.addListener(() {
//      final sec = _animation.lastElapsedDuration.inSeconds;
//      if (sec > 3) {
//        final randMod = random.nextInt(100);
//        if (randMod == 0) return;
//        if (sec % randMod == 0) {
//          final points = generatePoints(random.nextInt(3));
//          if (points.length > 0) {
//            debugPrint('Point {ttl: ${points.first.ttl}}');
//            _map.points = points;
//          }
//        }
//      }
//    });
//  }

}
