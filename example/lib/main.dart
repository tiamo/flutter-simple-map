import 'dart:math';

import 'package:flutter/material.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  static Random random = Random();

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
            OWMapContainer(
              options: OWMapOptions(),
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
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
