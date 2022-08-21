import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:simple_map/simple_map.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());
  Wakelock.enable();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple Map Demo',
      debugShowCheckedModeBanner: false,
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

  SimpleMapOptions _mapOptions;
  SimpleMapController _mapController;

  Ticker _ticker;

  List<dynamic> _points = [];

  @override
  void initState() {
    _mapOptions = SimpleMapOptions(
      pointColor: Colors.blue,
    );
    _mapController = SimpleMapController();
    initRealtimeTicker();

    loadPoints().then((points) {
      _points = points;
      generateRandomPoints(1000);
    });

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

  Future<List> loadPoints() async {
    String points = await rootBundle.loadString('assets/points.json');
    return json.decode(points);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void generateRandomPoints(int num) {
    assert(_mapController != null);
    final List<SimpleMapPoint> points = generatePoints(random.nextInt(num));

    _mapController.points = points;
  }

  List<SimpleMapPoint> generatePoints(
    int num, {
    int maxTTL = 120,
    Color color = Colors.blue,
  }) {
    if (num <= 0 || _points.length == 0) {
      return [];
    }
    return List.generate(num, (index) {
      var p = _points[random.nextInt(_points.length)];
      return SimpleMapPoint(
        lat: double.tryParse(p[0]),
        lng: double.tryParse(p[1]),
        color: color,
        ttl: Duration(seconds: random.nextInt(maxTTL) + 5),
        animator: random.nextInt(3) == 1 ? RayMapPointAnimator() : null,
      );
    });
  }

  bool liveEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Map Demo'),
      ),
      backgroundColor: Color(0xffff9f9f9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SimpleMap(
                controller: _mapController,
                options: _mapOptions,
              ),
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
      floatingActionButton: Wrap(
        spacing: 10,
        children: [
          FloatingActionButton(
            onPressed: () {
              generateRandomPoints(random.nextInt(10) + 1);
            },
            tooltip: 'Add random points',
            child: Icon(Icons.add_circle),
          ),
          FloatingActionButton(
            onPressed: () {
              _mapController.flyTo(0, 0, zoom: 5.0);
            },
            tooltip: 'Zoom In',
            child: Icon(Icons.zoom_in),
          ),
          FloatingActionButton(
            onPressed: () {
              final point = generatePoints(1)[0];
              _mapController.addMarker(
                SimpleMapMarker(
                  lat: point.lat,
                  lng: point.lng,
                  color:
                      Colors.primaries[random.nextInt(Colors.primaries.length)],
                  image: NetworkImage(
                    'https://avatars.githubusercontent.com/u/1963342?s=50',
                    // 'https://avatars.githubusercontent.com/u/14101776?s=50',
                  ),
                ),
              );
            },
            tooltip: 'Add marker',
            child: Icon(Icons.add_card),
            backgroundColor: Colors.deepOrangeAccent,
          ),
        ],
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
